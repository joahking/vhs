#!/usr/bin/env ruby

bin_dir = File.expand_path(File.dirname(__FILE__))
shell_script_path = File.join(bin_dir, 'dynamize_cassettes.sh')

`#{shell_script_path}`
puts 'VCR cassettes have being dynamized'

