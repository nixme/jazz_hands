require 'jazz_hands/version'

require 'pry'
require 'pry-rails' if defined?(Rails)
require 'pry-doc'
require 'pry-git'
require 'pry-remote'
require 'pry-stack_explorer'
require 'awesome_print'
require 'jazz_hands/hirb_ext'
require 'pry-debugger'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/kernel/reporting'
require 'readline'

module JazzHands

  ### Options ###

  # Color the prompt?
  #
  # A different setting than Pry.color since some may like colored output, but a
  # plain prompt.
  #
  # Default: 'true' for GNU readline or rb-readline which correctly count line
  # widths with color codes when using \001 and \002 hints. 'false' for
  # libedit-based wrapper (standard on OS X unless ruby is explicitly compiled
  # otherwise).
  #
  mattr_accessor :colored_prompt
  self.colored_prompt = (Readline::VERSION !~ /EditLine/)

  # Separator between application name and input in the prompt.
  #
  # Default: right angle quote, or '>' when using rb-readline which doesn't
  # handle mixed encodings well.
  #
  mattr_accessor :prompt_separator
  self.prompt_separator = defined?(RbReadline) ? '>' : "\u00BB"


  class << self
    # Initialize jazz_hands. Requires relevant gems and then spruces up the command prompt.
    #
    # Call before binding.pry in a non-rails project:
    #
    #   JazzHands.initialize!
    #   binding.pry
    #
    # Called automatically for Rails apps upon Rails initialization
    def initialize!(options={})
      name = options[:name] || ''

      silence_warnings do
          # We're managing the loading of plugins. So don't let pry autoload them.
        Pry.config.should_load_plugins = false

        # Use awesome_print for output, but keep pry's pager. If Hirb is
        # enabled, try printing with it first.
        Pry.config.print = ->(output, value) do
          return if JazzHands._hirb_output && Hirb::View.view_or_page_output(value)
          pretty = value.ai(indent: 2)
          Pry::Helpers::BaseHelpers.stagger_output("=> #{pretty}", output)
        end

        # Friendlier prompt - line number, app name, nesting levels look like
        # directory paths.
        #
        # Heavy use of lazy lambdas so configuration (like Pry.color) can be
        # changed later or even during console usage.
        #
        # Custom color helpers using hints \001 and \002 so that good readline
        # libraries (GNU, rb-readline) correctly ignore color codes when
        # calculating line length.

        color = -> { Pry.color && JazzHands.colored_prompt }
        red  = ->(text) { color[] ? "\001\e[0;31m\002#{text}\001\e[0m\002" : text.to_s }
        blue = ->(text) { color[] ? "\001\e[0;34m\002#{text}\001\e[0m\002" : text.to_s }
        bold = ->(text) { color[] ? "\001\e[1m\002#{text}\001\e[0m\002"    : text.to_s }

        separator = -> { red.(JazzHands.prompt_separator) }
        colored_name = -> { blue.(name) }

        line = ->(pry) { "[#{bold.(pry.input_array.size)}] " }
        target_string = ->(object, level) do
          level = 0 if level < 0
          unless (string = Pry.view_clip(object)) == 'main'
            "(#{'../' * level}#{string})"
          else
            ''
          end
        end

        Pry.config.prompt = [
          ->(object, level, pry) do      # Main prompt
            "#{line.(pry)}#{colored_name.()}#{target_string.(object, level)} #{separator.()}  "
          end,
          ->(object, level, pry) do      # Wait prompt in multiline input
            spaces = ' ' * (
            "[#{pry.input_array.size}] ".size +  # Uncolored `line.(pry)`
              name.size +
              target_string.(object, level).size
            )
            "#{spaces} #{separator.()}  "
          end
        ]
      end
    end

    # Enable syntax highlighting as you type in the Rails console via coolline and
    # coderay (MRI 1.9.3+ only). Disabled by default as it's a bit buggy.
    #
    # Call from a Rails initializer:
    #
    #   JazzHands.enable_syntax_highlighting_as_you_type!
    #
    def enable_syntax_highlighting_as_you_type!
      raise 'Syntax highlighting only supported on 1.9.3+' unless RUBY_VERSION >= '1.9.3'

      # Use coolline with CodeRay for syntax highlighting as you type.
      # Only works on >= 1.9.3 because coolline depends on io/console.

      require 'coolline'
      require 'coderay'

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
    alias :enable_syntax_highlighting_as_you_type :enable_syntax_highlighting_as_you_type!
  end

  ### Internal methods ###

  mattr_accessor :_hirb_output
end

if defined?(Rails)
  require 'jazz_hands/railtie'
else
  JazzHands.initialize!
end