#!/bin/env ruby
# encoding: utf-8
require 'trollop'
require 'blomming_api'
require './shop_items_csv_format.rb'

#
# command line arguments and options
#
opts = Trollop::options do
  version "#{$0} v.1.0 by giorgio.robino@gmail.com"
  banner <<-EOS

#{version}

  Export all items data from a specified Blomming shop (shop_id)
  creating a CSV file (shop_id.csv), using API endpoint: 

    https://api.blomming.com/docs/v1/shops/items-GET.html

  CSV file columns format:

    id,title,description,created_at,price,original_price,photo1,photo2,photo3,photo4,quantity

Usage:
  $ ruby csv_export.rb config_file.yml [options] 

Examples:
  $ ruby #{$0} myconfig.yml -d --shop-id solyarismusic
  $ ls solyarismusic.*
  solyarismusic.csv  solyarismusic.json

  $ ruby #{$0} ./config/solyarismusic.yml  -s microregali -t '|'

Options:
EOS

  opt :shop_id, "shop_id, alias shop_name", :type => String, :default => "solyarismusic", :short => "-s"
  opt :debug, "debug mode produce verbose log and generate JSON file with all data supplied by API", :default => false, :short => "-d"
  opt :text_quote, "text column delimiter character in CSV file", :default => "\"", :short => "-t"
  opt :col_sep, "columns delimiter character in CSV file", :default => ",", :short => "-c"
  opt :output_directory_path, "directory path where create CSV and JSON output files", :default => "", :short => "-p"
end
 
config_file = ARGV[0]

Trollop::die "argument config_file not found" if ARGV.empty?
Trollop::die "config_file #{config_file} must exist" unless File.exist?(config_file) if config_file

#
# assegna variabili "globali" allo script
#
shop_id = opts.shop_id 
debug = opts.debug
col_sep = opts.col_sep
text_quote = opts.text_quote
path = opts.output_directory_path

filename_csv = "#{path}#{shop_id}.csv"
filename_json = "#{path}#{shop_id}.csv"


# create a Blomming Client instance handler
c = BlommingApi::Client.new config_file

# get all items (all pages) of specified shop_id
# pass to all_pages helper a ruby block containing shop_items API call
# all_pages return an hash array containing all items!
all_items = c.all_pages { |page, per_page| 
  c.shop_items(shop_id, {page: page, per_page: per_page})
}

# create CSV file
csv_create filename_csv, col_sep

# for every item: add row in CSV file
all_items.each_with_index { |item, index|
  csv_update filename_csv, item, index, col_sep, text_quote, debug
}

puts "created CSV file: #{filename_csv} containing #{all_items.size} items."

if debug
  # save pretty JSON data in a file
  File.open(filename_json, 'w:utf-8') { |f| f.write MultiJson.dump(all_items, :pretty => true) }
  puts "created JSON file: #{filename_json} containing #{all_items.size} items."
end