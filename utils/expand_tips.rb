#!/usr/bin/env ruby

require 'yaml'
require 'pry'

#### Function defs

# Replace each tip with the content if the tip is present as a lookup key.
#   map works here because tips is an array
def tips_substitution(tips, lookup)
  tips&.map{|tip| lookup.fetch(tip, tip)}
end

# iterate over each key (clc, hbpc, ...) of reports
#   expand values of site tips that match the key of the report tips hash.
#   Must use merge because reports is a hash
def reports_substitution(reports)
  reports.merge!(reports) do |key, report, _|
    tips_content =  report['tips']
    sites = report['sites']

    # Do tip text expansion for each site
    sites.merge!(sites) do |key, site, _|
      if(site.keys.include? 'tips')
        site['tips'] = tips_substitution(site['tips'], tips_content)
      end
      site
    end

    # Replace with expanded text
    report['sites'] = sites
    report
  end
end

#### Begin Main
if ARGV.length < 1
  puts "Missing arg: path to config file."
  exit 1
end

fpath = ARGV[0]

if !File.exists?(fpath)
  puts "File not found: #{fpath}" 
end

config = YAML.load_file fpath

replacement_reports = reports_substitution config['default']
config['default'] = replacement_reports

puts config.to_yaml
