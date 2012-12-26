require 'pry'
require 'pry-rails'
require 'pry-doc'
require 'pry-git'
require 'pry-remote'
require 'pry-stack_explorer'
require 'awesome_print'
require 'jazz_hands/hirb_ext'
require 'pry-debugger'


module JazzHands
  class Railtie < Rails::Railtie
    initializer 'jazz_hands.initialize' do |app|
      silence_warnings do
        # We're managing the loading of plugins. So don't let pry autoload them.
        Pry.config.should_load_plugins = false

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
          level = 0 if level < 0
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
  end
end
