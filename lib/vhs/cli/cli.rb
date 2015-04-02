require 'thor'

require 'vhs/cli/cassettes'
require 'vhs/cli/config'
require 'vhs/loader'

module VHS
  module CLI

    class CLI < Thor
      include Thor::Actions

      #TODO add aliases
      desc 'config SUBCOMMAND ARGS', 'Configures VHS for test frameworks'
      subcommand 'config', Config

      desc 'list CASSETTE', 'List your cassettes. CASSETTE values are: all (default), error, a regexp to match an HTTP status code (must start with a digit)'
      def list(cassette = 'all')
        case cassette
        when 'all'
          puts Cassettes.new.all_str
        when 'error'
          puts Cassettes.new.error_str
        else
          puts Cassettes.new.regexp_str(cassette)
        end
      end

      desc 'update CASSETTE', 'Updates cassettes. CASSETTE values are: all (default), a filepath to a cassette, error, a regexp to match an HTTP status code (must start with a digit)'
      def update(cassette = 'all')
        cassettes = case cassette
                    when 'all'
                      puts 'Updating all cassettes'
                      Cassettes.new.all
                    when 'error'
                      puts 'Updating error cassettes'
                      Cassettes.new.error
                    when /\A\d.?.?/
                      puts "Updating cassettes by regexp #{ cassette }"
                      Cassettes.new.regexp(cassette)
                    else
                      [cassette] # it is a filename
                    end

        Loader.load
        cassettes.each do |cassette|
          puts "Updating cassette #{ cassette }"
          VHS.cassette_update cassette
        end
      end

      #TODO move to XING dynamizers
      desc 'dynamize', 'Replaces api urls in cassettes with <%= api_host %>'
      def dynamize
        Cassettes.new.all.each do |cassette|
          gsub_file cassette, /uri: http:\/\/.*.env.xing.com:3007\/rest/, 'uri: <%= api_host %>'
        end
        puts 'Cassettes have being dynamized'
      end

      desc 'clean', 'Removes all cassettes not added to git'
      def clean
        Cassettes.new.clean
      end

      private

      def self.source_root
        @source_root ||= Loader.new.cassettes_path
      end

    end
  end
end

