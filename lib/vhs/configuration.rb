class VHS::Configuration
  # Determines whether VHS is turned on. Defaults to true.
  attr_accessor :turned_on

  # The sandbox host your test suite calls. Must be set, lib/vhs.rb shows how.
  attr_accessor :api_host

  # Configuration defaults
  def initialize
    #TODO use this one on turn_on method
    @turned_on = true
  end
end

