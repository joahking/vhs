VCR.configure do |vcr|
  vcr.cassette_library_dir = Rails.root.join("spec", "fixtures", "vcr")
  vcr.hook_into :typhoeus
end

VHS.configure do |vhs|
  vhs.api_host = AppConfig.sandbox.rest_url
  #TODO logging, logger, cassettes refresh frequency and forced refresh
end

RSpec.configure do |rspec|
  # using `vhs: false` as tag in context, describe and it blocks turns off VHS
  rspec.around(:example, vhs: false) do |example|
    VHS.turn_off
    example.run
    VHS.turn_on
  end

  rspec.before(:each) do
    # disconnects Typhoeus response_token check as it break VHS stubs
    allow_any_instance_of(RESTApi::Request).to receive(:check_response_token).and_return(true)
  end

  rspec.after(:each) do
    #TODO
    # - check if this is still needed
    # - benchmark whether it is expensive in the general case
    # - find more cleanup strategies
    VHS.remove_cassettes
  end
end

VHS.load

