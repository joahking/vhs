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
      request_cassette = find_cassette cassette_name

      if request_cassette.nil?
        VCR.insert_cassette cassette_name, erb: { api_host: config.api_host }

        #TODO pass a logger in configuration and use it
        puts "~ [vhs] Loaded cassette #{ cassette_name }"
      else
        puts "~ [vhs] Existing cassette #{ cassette_name }"
      end
    end
  end

  def write_cassette(request)
    #TODO if turned_on?
    cassette_name = cassette_name request
    request_cassette = find_cassette cassette_name

    if request_cassette
      #TODO pass a logger in configuration and use it
      puts "~ [vhs] Wrote cassette #{ cassette_name }"
      request_cassette.eject
    end
  end

  #TODO the logic of find_cassette and cassette_name is duplicated in VCR
  #OPTIMIZE this uses VCR private method
  def find_cassette(cassette_name)
    VCR.send(:cassettes).select do |c|
      c.name == cassette_name
    end.first
  end

  # The cassette name is the request path.
  def cassette_name(request)
    uri = URI request.url
    #TODO use uri.host in name to use other apis
    return uri.path
  end

end

