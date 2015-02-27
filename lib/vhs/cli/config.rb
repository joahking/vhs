module VHS
  class Config < Thor
    include Thor::Actions

    desc 'cli', 'Configures the VHS CLI to run advanced commands'
    def cli
      copy_file 'cli.yml', '.vhs.yml'
      append_to_file '.gitignore', '.vhs.yml'
      puts "VHS CLI configured"
    end

    desc 'rspec DESTINATION_PATH', 'Configures rspec to use VHS'
    method_option :destination_path, default: 'spec/support/vhs.rb'
    def rspec
      destination_path = options[:destination_path]
      copy_file 'rspec/vhs.rb', destination_path
      puts "VHS configured for RSpec"
    end

private

    def self.source_root
      File.join File.dirname(__FILE__), '../../generators/'
    end

  end
end

