#!/usr/bin/env ruby
require 'fileutils'

bin_dir = File.expand_path(File.dirname(__FILE__))
rspec_config_file = File.open File.join(bin_dir, '..', 'lib/generators/rspec/vhs.rb')
destination_path = ARGV[0] || 'spec/support'

FileUtils.cp rspec_config_file, destination_path
puts "Spec config file vhs.rb copied to #{destination_path }"

