#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'
require_relative '_show_shop_item_details'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint 'sell_shop_item_find'"	
  puts "  usage: #{$0} <config_file.yml> <item id>"
  puts "example: ruby #{$0} yourconfig.yml 540272"
  exit 
end

config_file, item_id = ARGV

blomming = BlommingApi::Client.new config_file

item = blomming.sell_shop_item_find item_id

show_details item