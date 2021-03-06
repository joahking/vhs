require 'typhoeus'
require 'vcr'

require 'vhs/version'
require 'vhs/cassetter'
require 'vhs/configuration'
require 'vhs/loader'

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
    #TODO
    # - add a param to leave VCR on?
    # - allow to pass a block to run with VHS on?
    VCR.turn_on!
    @active = true
  end

  def turn_off
    #TODO
    # - add a param to leave VCR on?
    # - allow to pass a block to run with VHS off?

    # we need to save all cassettes before turning off, to avoid VCR exceptions
    eject_all_cassettes

    VCR.turn_off!
    @active = false
  end

  # Public: forces the update of cassettes.
  def cassette_force_updates
    @cassette_forced_update = true
  end

  def cassette_forced_updates?
    @cassette_forced_update
  end

  # Loads a cassette for the request unless one is already loaded.
  def load_cassette(request)
    if turned_on?
      cassette_name = VCR.cassette_name request
      request_cassette = find_cassette cassette_name

      if request_cassette.nil?
        VCR.insert_cassette cassette_name, cassette_options

        puts "~ [vhs] Loaded cassette #{ cassette_name }" if config.log_load
      elsif config.log_load
        puts "~ [vhs] Existing cassette #{ cassette_name }"
      end
    end
  end

  #TODO move cassette options to spec config file?
  def cassette_options
    {
      erb: { api_host: config.api_host },
      allow_playback_repeats: true,
      record: cassette_forced_updates? ? :all : :once,
      match_requests_on: [:method, :uri, :body, :params]
    }
  end

  def write_cassette(request)
    #TODO if turned_on?
    cassette_name = VCR.cassette_name request
    request_cassette = find_cassette cassette_name

    if request_cassette
      puts "~ [vhs] Wrote cassette #{ cassette_name }" if config.log_write
      request_cassette.eject
    end
  end

  def cassette_update(cassette_filename)
    Cassetter.update cassette_filename
  end

  def eject_all_cassettes
    VCR.send(:cassettes).each do |cassette|
      cassette.eject
    end
  end

  #TODO move to Cassetter, together with many methods here, and let this module
  # just proxy methods to classes
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

