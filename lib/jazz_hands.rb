require 'jazz_hands/version'
require 'jazz_hands/railtie' if defined?(Rails)
require 'active_support'
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
