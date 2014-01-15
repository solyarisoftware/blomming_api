#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoints: sell_shop_sections"	
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

blomming = BlommingApi::Client.new config_file

sections = blomming.sell_shop_sections

puts MultiJson.dump sections, :pretty => true
