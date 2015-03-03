require 'thor'
require 'vhs/cli/cassettes'
require 'vhs/cli/config'
require 'vhs/cli/cli_loader'

module VHS

  #TODO add aliases
  class CLI < Thor
    desc 'config SUBCOMMAND ARGS', 'Configures VHS for test frameworks'
    subcommand 'config', Config

    desc 'cassettes SUBCOMMAND ARGS', 'Cassettes handling commands'
    subcommand 'cassettes', Cassettes

    desc 'list CASSETTE', 'List your cassettes. CASSETTE values are: all (default), error, a regexp to match an HTTP status code (must start with a digit)'
    def list(cassette = 'all')
      path = VHS::CLILoader.new.cassettes_path

      case cassette
      when 'all'
        puts 'Listing all cassettes'
        puts `#{ all_cassettes_cmd(path) }`
      when 'error'
        puts 'Listing error cassettes'
        puts `#{ error_cassettes_cmd(path) }`
      else
        puts "Cassettes by regexp #{ cassette }"
        puts `#{ all_cassettes_cmd(path, cassette) }`
      end
    end

    desc 'update CASSETTE', 'Updates cassettes. CASSETTE values are: all (default), a filepath to a cassette, error, a regexp to match an HTTP status code (must start with a digit)'
    def update(cassette = 'all')
      loader = VHS::CLILoader.new
      path = loader.cassettes_path

      cassettes = case cassette
                  when 'all'
                    puts 'Updating all cassettes'
                    `#{ all_cassettes_cmd(path) } | #{ clean_output_cmd }`
                  when 'error'
                    puts 'Updating error cassettes'
                    `#{ error_cassettes_cmd(path) } | #{ clean_output_cmd }`
                  when /\A\d.?.?/
                    puts "Updating cassettes by regexp #{ cassette }"
                    `#{ all_cassettes_cmd(path, cassette) } | #{ clean_output_cmd }`
                  else
                    cassette # it is a filename
                  end

      loader.load_vhs
      cassettes.split(/\n/).each do |cassette|
        puts "Updating cassette #{ cassette }"
        VHS.cassette_update cassette
      end
    end

    private

    # Private: finds all cassettes.
    # - path the path to the cassettes
    # - code a regexp for the HTTP status code, if not passed all cassettes are found
    # Returns a list of cassettes with code behind, \n separated.
    def all_cassettes_cmd(path, code = '')
      "grep 'code: #{ code }' #{ path } -R"
    end

    # Private: finds all cassettes which code is not 200.
    # - path the path to the cassettes
    # Returns a list of cassettes with code behind, \n separated.
    def error_cassettes_cmd(path)
      "grep 'code:' #{ path } -R | grep -v 'code: 200'"
    end

    # Private: removes everything from output leaving just filenames.
    def clean_output_cmd
      "sed 's/\.yml.*/.yml/g'"
    end

  end

end

