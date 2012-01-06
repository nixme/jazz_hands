require 'pry'
require 'pry-doc'
require 'pry-git'
require 'pry-remote'
require 'awesome_print'

# Enable pry-nav by default on MRI 1.9.3 only
require 'pry-nav' if RUBY_VERSION >= '1.9.3'


module JazzHands
  class Railtie < Rails::Railtie
    initializer 'jazz_hands.initialize' do |app|
      silence_warnings do
        ::IRB = Pry    # Replace IRB with Pry completely

        # Use awesome_print for output, but keep pry's pager
        Pry.config.print = ->(output, value) do
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

        require 'jazz_hands/hirb_ext'
      end
    end
  end
end
