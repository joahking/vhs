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

  end
end

