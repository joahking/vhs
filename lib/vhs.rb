require "vhs/version"
require "vcr"
require "typhoeus"

module VHS
  extend self

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
        VCR.insert_cassette cassette_name
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
    elems = uri.path.split "/"
    new_elems = []
    elems.each_index do |idx|
      new_elems[idx] = if idx > 0 && is_integer?(elems[idx])
                         "#{ elems[idx -1].singularize }_id"
                       else
                         elems[idx]
                       end
    end
    new_elems.join "/"
  end

  def is_integer?(str)
    str.to_i.to_s == str
  end
end

