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

  def turn_on
    VCR.turn_on!
    @active = true
  end

  def turn_off
    VCR.turn_off!
    @active = false
  end

  # Loads a cassette for the request unless one is already loaded.
  def load_cassette(request)
    if turned_on?
      cassette_name = VCR.cassette_name request
      request_cassette = find_cassette cassette_name

      if request_cassette.nil?
        VCR.insert_cassette cassette_name, cassette_options

        #TODO pass a logger in configuration and use it
        puts "~ [vhs] Loaded cassette #{ cassette_name }"
      else
        puts "~ [vhs] Existing cassette #{ cassette_name }"
      end
    end
  end

  #TODO move cassette options to spec config file?
  def cassette_options
    {
      erb: { api_host: config.api_host },
      allow_playback_repeats: true,
      record: :once
      # match_requests_on: [:method, :uri, :query]
    }
  end

  def write_cassette(request)
    #TODO if turned_on?
    cassette_name = VCR.cassette_name request
    request_cassette = find_cassette cassette_name

    if request_cassette
      #TODO pass a logger in configuration and use it
      puts "~ [vhs] Wrote cassette #{ cassette_name }"
      request_cassette.eject
    end
  end

  def remove_cassettes
    VCR.remove_cassettes
  end

private

  #TODO the logic of find_cassette and cassette_name is duplicated in VCR
  #OPTIMIZE this uses VCR private method
  def find_cassette(cassette_name)
    #TODO do not use VCR private :cassettes method
    VCR.send(:cassettes).select do |c|
      c.name == cassette_name
    end.first
  end

end

