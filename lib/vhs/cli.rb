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
  end

end

