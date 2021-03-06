#!/usr/bin/env ruby

require 'yaml'

if ARGV.length < 1
  puts "Missing arg: path to config file."
  exit 1
end

fpath = ARGV[0]

if !File.exists?(fpath)
  puts "File not found: #{fpath}" 
end

config = YAML.load_file fpath
puts "Done."
