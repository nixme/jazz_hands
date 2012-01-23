require 'pry'
require 'pry-doc'
require 'pry-git'
require 'pry-remote'
require 'awesome_print'
require 'jazz_hands/hirb_ext'

# Enable pry-nav by default on MRI 1.9.3 only
require 'pry-nav' if RUBY_VERSION >= '1.9.3'


module JazzHands
  class Railtie < Rails::Railtie
    initializer 'jazz_hands.initialize' do |app|
      silence_warnings do
        ::IRB = Pry                      # Replace IRB with Pry completely

        # Rails 3.2 injects commands into IRB::ExtendCommandBundle. Make sure
        # Pry is compatible enough so Rails boot works.
        unless defined? IRB::ExtendCommandBundle   # Latest Pry defines it
          module IRB::ExtendCommandBundle; end
        end

        # We're managing the loading of plugins, especially pry-nav which
        # shouldn't be loaded on 1.9.2. So don't let pry autoload them.
        Pry.config.should_load_plugins = false
        Pry.config.plugins.enabled = false

        # Use awesome_print for output, but keep pry's pager. If Hirb is
        # enabled, try printing with it first.
        Pry.config.print = ->(output, value) do
          return if JazzHands.hirb_output && Hirb::View.view_or_page_output(value)
          pretty = value.ai(indent: 2)
          Pry::Helpers::BaseHelpers.stagger_output("=> #{pretty}", output)
        end

        # Friendlier prompt - nesting levels look like directory paths
        name = app.class.parent_name.underscore
        colored_name = Pry::Helpers::Text.blue(name)
        raquo = Pry::Helpers::Text.red("\u00BB")
        line = ->(pry) { "[#{Pry::Helpers::Text.bold(pry.input_array.size)}] " }
        target_string = ->(object, level) do
          unless (string = Pry.view_clip(object)) == 'main'
            "(#{'../' * level}#{string})"
          else
            ''
          end
        end
        Pry.config.prompt = [
          ->(object, level, pry) do
            "#{line.(pry)}#{colored_name}#{target_string.(object, level)} #{raquo}  "
          end,
          ->(object, level, pry) do
            spaces = ' ' * (
              "[#{pry.input_array.size}] ".size +  # Uncolored `line.(pry)`
              name.size +
              target_string.(object, level).size
            )
            "#{spaces} #{raquo}  "
          end
        ]
      end
    end

    console do
      # Mimic IRB's ExtendCommandBundle API now that Rails 3.2 uses it to inject
      # commands.
      if defined? IRB::ExtendCommandBundle
        # We inject to the TOPLEVEL_BINDING's self so only the repl's Object
        # instance is affected, not all objects.
        TOPLEVEL_BINDING.eval('self').extend IRB::ExtendCommandBundle
      end
    end
  end
end
