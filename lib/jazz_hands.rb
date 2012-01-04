require 'jazz_hands/version'
require 'jazz_hands/railtie' if defined?(Rails)

module JazzHands

  # Enable pry-nav.
  #
  # For performance reasons, pry-nav is enabled by default for only MRI 1.9.3+.
  # To use with MRI 1.9.2, call this method from a Rails initializer:
  #
  #   JazzHands.enable_pry_nav
  #
  def self.enable_pry_nav
    require 'pry-nav'
  end
end
