require 'pry'
require 'coolline' if RUBY_VERSION >= '1.9.3'
require 'coderay'
require 'awesome_print'

module JazzHands
  class Railtie < Rails::Railtie
    initializer 'jazz_hands.initialize' do |app|
      silence_warnings do
        ::IRB = Pry    # Replace IRB with Pry completely

        # Use coolline with CodeRay for syntax highlighting as you type
        # Only works on >= 1.9.3 because coolline depends on io/console
        if RUBY_VERSION >= '1.9.3'
          Pry.config.input = Coolline.new do |c|
            c.transform_proc = proc do
              CodeRay.scan(c.line, :ruby).term
            end

            c.completion_proc = proc do
              word = c.completed_word
              Object.constants.map(&:to_s).select { |w| w.start_with? word }
            end
          end
        end

        # Use awesome_print for output, but keep pry's pager
        Pry.config.print = ->(output, value) do
          pretty = value.ai(indent: 2)
          Pry::Helpers::BaseHelpers.stagger_output("=> #{pretty}", output)
        end

        # Friendlier prompt - nesting levels look like directory paths
        name = app.class.parent_name.underscore
        colored_name = Pry::Helpers::Text.blue(name)
        raquo = Pry::Helpers::Text.red("\u00BB")
        target_string = ->(object, level) do
          unless (string = Pry.view_clip(object)) == 'main'
            "(#{'../' * level}#{string})"
          else
            ''
          end
        end
        Pry.config.prompt = [
          ->(object, level, _) do
            "#{colored_name}#{target_string.(object, level)} #{raquo}  "
          end,
          ->(object, level, _) do
            "#{' ' * (name.size + target_string.(object, level).size)} #{raquo}  "
          end
        ]
      end
    end
  end
end
