require 'thor'
require 'vhs/cli/cassettes'
require 'vhs/cli/config'
require 'vhs/cli/cli_loader'

module VHS

  class CLI < Thor
    desc 'config SUBCOMMAND ARGS', 'Configures VHS for test frameworks'
    subcommand 'config', Config

    desc 'cassettes SUBCOMMAND ARGS', 'Cassettes handling commands'
    subcommand 'cassettes', Cassettes

    desc 'list CASSETTE', 'List your cassettes. CASSETTE values are: all (default), error, a regexp to match an HTTP status code'
    def list(cassette = 'all')
      path = VHS::CLILoader.new.cassettes_path

      case cassette
      when 'all'
        puts 'Cassettes: all'
        puts `find #{ path } -name "*.yml"`
      when 'error'
        puts 'Cassettes: error'
        puts `grep 'code: [^200]' #{ path } -Rn | sed -E 's/:[0-9]+://g'`
      else
        puts "Cassettes: code #{ cassette }"
        puts `grep 'code: #{ cassette }' #{ path } -Rn | sed 's/\.yml.*/.yml/g'`
      end
    end
  end

end

