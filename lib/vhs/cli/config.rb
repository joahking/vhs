module VHS
  class Config < Thor

    desc 'rspec DESTINATION_PATH', 'Configures rspec to use VHS'
    method_option :destination_path, default: 'spec/support'
    def rspec
      destination_path = options[:destination_path]

      dir = File.expand_path(File.dirname(__FILE__))
      rspec_config_file = File.open File.join(dir, '../../../lib/generators/rspec/vhs.rb')

      FileUtils.cp rspec_config_file, destination_path

      puts "Spec config file vhs.rb copied to #{ destination_path }"
    end

  end
end

