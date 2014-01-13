#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint 'sell_shop_item_add_tags'"	
  puts "  usage: #{$0} <config_file.yml> <item id>"
  puts "example: ruby #{$0} yourconfig.yml 651360"
  exit 
end

config_file, item_id = ARGV

blomming = BlommingApi::Client.new config_file

tags = ["musica", "musica ambient", "musica elettronica"]

item = blomming.sell_shop_item_tags_add(tags, item_id, {})

show_details item