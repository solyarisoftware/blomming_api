#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil? 
  puts "   goal: test endpoint: items_list"
  puts "  usage: #{$0} <config_file.yml> <item_id (numeric item id)>"
  puts "example: ruby #{$0} yourconfig.yml 540272" 
  exit
end

config_file = ARGV[0]
item_id = ARGV[1].to_i

c = BlommingApi::Client.new config_file 

items = c.all_pages (:stdout) { |page, per_page|
  c.items_list( item_id, {page: page, per_page: per_page} )
} 

puts "JSON dump for #{items.size} item(s) with item_id: #{item_id}\":"
puts MultiJson.dump items, :pretty => true