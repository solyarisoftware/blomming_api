#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint 'sell_shop_item_find'"	
  puts "  usage: #{$0} <config_file.yml> <item id>"
  puts "example: ruby #{$0} yourconfig.yml 540272"
  exit 
end

config_file, item_id = ARGV

blomming = BlommingApi::Client.new config_file

item = blomming.sell_shop_item_find item_id

#puts MultiJson.dump item, :pretty => true

puts "              item_id: #{item["id"]}" 
puts "                title: #{item["title"]}"

# truncate description: get first 71 chars of first line
puts "          description: #{item["description"].lines.first[0, 70]}" 
puts "           created_at: #{item["created_at"]}" 
puts "                price: #{item["price"]}"
puts "       original_price: #{item["original_price"]}" 
puts "             currency: #{item["currency"]}" 
puts "               photos: #{item["photos"].join(',')}"
puts "             quantity: #{item["quantity"]}" 
puts "              shop id: #{item["shop"]["id"]}"
puts "            shop name: #{item["shop"]["name"]}"
puts

# SKUs list
sku_ids = BlommingApi::PublicHelpers::collect_key_values item["skus"], "id"
puts "            sku id(s): #{sku_ids.join ','}"
puts

# Shipping
puts "  shipping profile id: #{item["shipping"]["profile_id"]}"
puts "shipping profile name: #{item["shipping"]["profile_name"]}"
puts "shipping ori. country: #{item["shipping"]["origin_country"]["name"]}"

destination_countries = BlommingApi::PublicHelpers::collect_key_values item["shipping"]["destinations"], "name"
puts "shipping destinations: #{destination_countries.join ','}"
puts

# Tags list
tags = BlommingApi::PublicHelpers::collect_key_values item["tags"], "name"
puts "                 tags: #{tags.join ','}"
puts

# Collections list
# 4 January 2013. collections not yet available as item details (possible bug server side)
collections = BlommingApi::PublicHelpers::collect_key_values item["collections"], "name" 
puts "          collections: #{collections.nil? ? "WARNING: key 'collections' not found!" : collections.join(',')}"
