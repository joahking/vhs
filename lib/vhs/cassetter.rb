require 'fileutils'
require 'yaml'

class VHS::Cassetter

  #TODO
  # - write this as an instance method
  # - allow to pass cassette with or w/o VCR.configuration.cassette_library_dir
  def self.update(cassette_filename)
    cassette_yaml = VCR::Cassette::Reader.new(cassette_filename, VHS::cassette_options[:erb]).read
    cassette_hash = YAML.load cassette_yaml
    cassette_request = cassette_hash.first[:request]

    request_options = {
      body:    cassette_request[:body],
      method:  cassette_request[:method],
      headers: { Accept: 'application/json' } # other headers make the servers raise
    }
    if cassette_request.respond_to? :params
      request_options[:params] = cassette_request[:params]
    end

    #TODO use a method directly on VHS
    VHS.config.forced_update = true # forces cassette to be recorded

    request = Typhoeus::Request.new cassette_request[:uri], request_options
    hydra   = Typhoeus::Hydra.new
    hydra.queue request
    hydra.run
  end

end

