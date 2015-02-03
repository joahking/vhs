require "vhs/version"
require "vhs/configuration"
require "vcr"
require "typhoeus"

module VHS
  extend self

  # Public: Modify VHS configuration
  #
  # Example:
  #   VHS.configure do |vhs|
  #     vhs.api_host = AppConfig.sandbox.rest_url
  #   end
  def configure
    yield configuration
  end

  # Accessor for VHS::Configuration
  def configuration
    @configuration ||= Configuration.new
  end
  alias :config :configuration

  def load
    require "vhs/typhoeus_stub"
    @active = true
  end

  def turned_on?
    @active
  end

  def turn_off
    @active = false
  end

  # Loads a cassette for the request unless one is already loaded.
  def load_cassette(request)
    if turned_on?
      cassette_name = cassette_name request
      if VCR.current_cassette.nil? ||
        (VCR.current_cassette && VCR.current_cassette.name != cassette_name)
        VCR.insert_cassette cassette_name, erb: { api_host: config.api_host }
      end
    end
  end

  # The cassette name is made out of the request path.
  # Example:
  # for a request with path "/rest/users/users/1"
  # the cassette name will be "/rest/users/users/user_id"
  def cassette_name(request)
    uri = URI request.url
    #TODO use uri.host in name to use other apis
    return uri.path
  end

end

