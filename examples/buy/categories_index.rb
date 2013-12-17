#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

puts "usage: #{$0} <config_file.yml>" and exit if ARGV.empty?

config_file =  ARGV[0]

# set country local: USA
country = "us"

# get all blomming categories
data = MultiJson.load BlommingApi::Client.new(config_file).categories_index ( {:locale => country} )

# list on stdout 
data.each { |item| puts item["name"] }