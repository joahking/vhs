require "vhs/version"
require "vcr"
require "typhoeus"

module VHS
  extend self

  def load
    # does this makes sense here?
    VCR.configure do |c|
      c.cassette_library_dir  = Rails.root.join("spec", "vcr")
      c.hook_into :typhoeus
    end

    require "vhs/typhoeus_stub"
  end

  def cassette_name(request)
    #TODO
    # extract cassette name from request
    "rest/users/users/user_id"
  end
end

