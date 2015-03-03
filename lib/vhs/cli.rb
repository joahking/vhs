require 'thor'
require 'vhs/cli/config'
require 'vhs/cli/cli_loader'

module VHS

  #TODO add aliases
  class CLI < Thor
    include Thor::Actions

    desc 'config SUBCOMMAND ARGS', 'Configures VHS for test frameworks'
    subcommand 'config', Config

    desc 'list CASSETTE', 'List your cassettes. CASSETTE values are: all (default), error, a regexp to match an HTTP status code (must start with a digit)'
    def list(cassette = 'all')
      case cassette
      when 'all'
        puts 'Listing all cassettes'
        puts `#{ all_cassettes_cmd }`
      when 'error'
        puts 'Listing error cassettes'
        puts `#{ error_cassettes_cmd }`
      else
        puts "Cassettes by regexp #{ cassette }"
        puts `#{ all_cassettes_cmd(cassette) }`
      end
    end

    desc 'update CASSETTE', 'Updates cassettes. CASSETTE values are: all (default), a filepath to a cassette, error, a regexp to match an HTTP status code (must start with a digit)'
    def update(cassette = 'all')
      cassettes = case cassette
                  when 'all'
                    puts 'Updating all cassettes'
                    `#{ all_cassettes_cmd } | #{ rm_trailing_chars_cmd }`
                  when 'error'
                    puts 'Updating error cassettes'
                    `#{ error_cassettes_cmd } | #{ rm_trailing_chars_cmd }`
                  when /\A\d.?.?/
                    puts "Updating cassettes by regexp #{ cassette }"
                    `#{ all_cassettes_cmd(cassette) } | #{ rm_trailing_chars_cmd }`
                  else
                    cassette # it is a filename
                  end

      VHS::CLILoader.new.load_vhs
      cassettes.split(/\n/).each do |cassette|
        puts "Updating cassette #{ cassette }"
        VHS.cassette_update cassette
      end
    end

    #TODO move to XING dynamizers
    desc 'dynamize', 'Replaces api urls in cassettes with <%= api_host %>'
    def dynamize
      cassettes = `#{ all_cassettes_cmd } | #{ rm_trailing_chars_cmd }`

      cassettes.split(/\n/).each do |cassette|
        gsub_file cassette, /uri: http:\/\/.*.env.xing.com:3007\/rest/, 'uri: <%= api_host %>'
      end
      puts 'Cassettes have being dynamized'
    end

    private

    def self.source_root
      @loader ||= VHS::CLILoader.new.cassettes_path
    end

    # Private: finds all cassettes.
    # - code: regexp for the HTTP status code, if not passed all cassettes are found
    # Returns a list of cassettes with code behind, \n separated.
    def all_cassettes_cmd(code = '')
      "grep 'code: #{ code }' #{ self.class.source_root } -R | #{ rm_trailing_colon_cmd }"
    end

    # Private: finds all cassettes which code is not 200.
    # Returns a list of cassettes with code behind, \n separated.
    def error_cassettes_cmd
      "grep 'code:' #{ self.class.source_root } -R | grep -v 'code: 200' | #{ rm_trailing_colon_cmd }"
    end

    # Private: removes everything from output leaving just filenames.
    def rm_trailing_chars_cmd
      "sed 's/\.yml.*/.yml/g'"
    end

    def rm_trailing_colon_cmd
      "sed 's/\.yml:/.yml/g'"
    end

  end

end

