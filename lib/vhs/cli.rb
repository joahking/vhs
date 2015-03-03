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

    desc 'list CODE', 'List your cassettes. CODE values are: all (default), error, or a regexp to match an HTTP status code, e.g. 200, 404, 503, 0, 2.., 5.., etc'
    def list(code = 'all')
      path = VHS::CLILoader.new.cassettes_path

      case code
      when 'all'
        puts 'Cassettes: all'
        puts `find #{ path } -name "*.yml"`
      when 'error'
        puts 'Cassettes: error'
        puts `grep 'code: [^200]' #{ path } -Rn | sed 's/\.yml.*/.yml/g'`
      else
        puts "Cassettes: code #{ code }"
        puts `grep 'code: #{ code }' #{ path } -Rn | sed 's/\.yml.*/.yml/g'`
      end
    end
  end

end

