# this file is almost a copy pasta of vcr/library_hooks/typhoeus.rb

# TODO: add Typhoeus::Hydra.register_stub_finder API to Typhoeus
#       so we can use that instead of monkey-patching it.
Typhoeus::Hydra::Stubbing::SharedMethods.class_eval do
  alias_method :find_stub_from_request_vcr, :find_stub_from_request

  def find_stub_from_request(request)
    #TODO move the if to a method
    if VHS::turned_on?
      if VCR.current_cassette.nil? || (VCR.current_cassette && VCR.current_cassette.name != VHS.cassette_name(request))
        VCR.insert_cassette VHS.cassette_name(request)
      end
      puts "cassette #{ VCR.current_cassette.object_id }:#{ VCR.current_cassette.name }"
    end

    find_stub_from_request_vcr request
  end
end

