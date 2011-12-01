require 'hirb'
require 'pry'

class << Hirb::View
  alias_method :enable_output_method_existing, :enable_output_method
  alias_method :disable_output_method_existing, :disable_output_method

  def enable_output_method
    @output_method = true

    # Adjust Pry output to try Hirb before its existing mechanism
    @old_pry_print = Pry.config.print
    Pry.config.print = ->(output, value) do
      view_or_page_output(value) || @old_pry_print.call(output, value)
    end

    enable_output_method_existing
  end

  def disable_output_method
    # Set Pry back to its existing output mechanism
    Pry.config.print = @old_pry_print

    disable_output_method_existing
  end
end
