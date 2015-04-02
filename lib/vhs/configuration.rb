class VHS::Configuration
  # Should VHS be turned on or off. Defaults to true = on.
  attr_accessor :turned_on

  # The sandbox host your test suite calls. Must be set, lib/vhs.rb shows how.
  attr_accessor :api_host

  # Should VHS log cassettes load. Defaults to false.
  attr_accessor :log_load

  # Should VHS log cassettes write. Defaults to false.
  attr_accessor :log_write

  # Configuration defaults
  def initialize
    #TODO use this one on turn_on method
    @turned_on = true
  end
end

