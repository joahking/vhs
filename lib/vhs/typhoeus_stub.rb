# this file is almost a copy pasta of vcr/library_hooks/typhoeus.rb

# TODO: add Typhoeus::Hydra.register_stub_finder API to Typhoeus
#       so we can use that instead of monkey-patching it.
Typhoeus::Hydra::Stubbing::SharedMethods.class_eval do
  alias_method :find_stub_from_request_vcr, :find_stub_from_request

  def find_stub_from_request(request)
    VHS.load_cassette request
    puts "cassette #{ VCR.current_cassette.object_id }:#{ VCR.current_cassette.name }"

    find_stub_from_request_vcr request
  end
end

::Typhoeus::Hydra.after_request_before_on_complete do |request|
  unless VCR.library_hooks.disabled?(:typhoeus) || request.response.mock?
    # guarantees that we save new responses to file
    VCR.current_cassette.eject if VCR.current_cassette
  end
end

