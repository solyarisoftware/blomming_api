#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'
require './_show_shop_item_details'

if ARGV[0].nil?
  puts "   goal: test endpoint 'sell_shop_items', 'sell_shop_item_find'"	
  puts "  usage: #{$0} <config_file.yml>"
  puts "example: ruby #{$0} yourconfig.yml"
  exit 
end

config_file = ARGV[0]

puts "retrieving shop items..."

c = BlommingApi::Client.new config_file

shop_id = c.username

# retrieve all shop's items data
items = c.all_pages do |page, per_page| 
  c.sell_shop_items page: page, per_page: per_page
end

# collect shop's items items_id
items_id = items.collect { |item| item["id"] }

puts "found #{items_id.size} items on shop '#{shop_id}':"
puts "#{items_id.join(',')}"

items_id.each do |item_id| 
  show_details c.sell_shop_item_find item_id
end  