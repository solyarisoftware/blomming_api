#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

# set country local: USA
country = "us"

# get all blomming categories
data = BlommingApi::Client.new(config_file).categories ( {locale: country} )

# list on stdout 
data.each { |item| puts item["name"] }