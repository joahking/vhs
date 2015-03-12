require 'vhs/loader'

module VHS
  module CLI
    class Cassettes

      # Public: returns a string with a list, \n separated, of all cassettes
      def all_str
        `#{ all_cassettes_cmd }`
      end

      # Public: returns an array with all cassettes
      def all
        `#{ all_cassettes_cmd } | #{ rm_trailing_chars_cmd }`.split(/\n/)
      end

      # Public: returns a string with a list, \n separated, of cassettes with
      # HTTP code not 2xx
      def error_str
        `#{ error_cassettes_cmd }`
      end

      # Public: returns an array with all cassettes with HTTP code not 2xx
      def error
        `#{ error_cassettes_cmd } | #{ rm_trailing_chars_cmd }`.split(/\n/)
      end

      # Public: returns a string with a list, \n separated, of cassettes with
      # HTTP code matching the regexp <code>
      def regexp_str(code)
        `#{ all_cassettes_cmd(code) }`
      end

      # Public: returns an array of cassettes with code matching the regexp <code>
      def regexp(code)
        `#{ all_cassettes_cmd(code) } | #{ rm_trailing_chars_cmd }`.split(/\n/)
      end

      private

      # Private: finds all cassettes.
      # - code: regexp for the HTTP status code, if not passed all cassettes
      #         are found
      # Returns a list, \n separated, of cassettes with code behind
      def all_cassettes_cmd(code = '')
        "grep 'code: #{ code }' #{ path } -R | #{ rm_trailing_colon_cmd }"
      end

      # Private: finds all cassettes which HTTP code is not 2xx.
      # Returns a list, \n separated, of cassettes with code behind
      def error_cassettes_cmd
        "grep 'code:' #{ path } -R | grep -v 'code: 2..' | #{ rm_trailing_colon_cmd }"
      end

      # Private: removes everything from output leaving just filenames.
      def rm_trailing_chars_cmd
        "sed 's/\.yml.*/.yml/g'"
      end

      def rm_trailing_colon_cmd
        "sed 's/\.yml:/.yml/g'"
      end

      def path
        @path ||= Loader.new.cassettes_path
      end

    end
  end
end

