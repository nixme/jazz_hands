require 'jazz_hands/version'
require 'jazz_hands/railtie' if defined?(Rails)

module JazzHands
  extend self

  # Enable syntax highlighting as you type in the Rails console via coolline and
  # coderay (MRI 1.9.3+ only). Disabled by default as it's a bit buggy.
  #
  # Call from a Rails initializer:
  #
  #   JazzHands.enable_syntax_highlighting_as_you_type
  #
  def enable_syntax_highlighting_as_you_type
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


  ### Internal methods ###

  attr_accessor :hirb_output
end
