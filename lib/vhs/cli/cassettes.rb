module VHS
  class Cassettes < Thor

    desc 'dynamize CASSETTES_PATH', 'Replaces api urls in cassettes with <%= api_host %>'
    method_option :cassettes_path, default: 'spec/fixtures/vhs'
    def dynamize
      cassettes_path = options[:cassettes_path]

      dir = File.expand_path(File.dirname(__FILE__))
      shell_script_path = File.join(dir, '../../../bin/dynamize_cassettes.sh')

      `#{ shell_script_path } #{ cassettes_path }`

      puts 'Cassettes have being dynamized'
    end

    desc 'update CASSETTE_PATH', 'Updates a cassette'
    def update(cassette_path)
      VHS::CLILoader.new.load_vhs
      VHS.cassette_update cassette_path
      puts "Cassette #{ cassette_path } has being updated"
    end

  end
end

