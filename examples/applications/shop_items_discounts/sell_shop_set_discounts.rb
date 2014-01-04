#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'
require './discounts_helper.rb'

if ARGV[0].nil? || ARGV[1].nil? || ARGV[2].nil?
  puts "   goal: set discount (as %) of a specific item on the shop\n"
  puts "  usage: #{$0} <config_file.yml> <discount_percentage> <item_id>" 
  puts "example:ruby #{$0} solyarismusic.yml 10 540268"
  exit
end

config_file, percentage_of_discount, item_id = ARGV

c = BlommingApi::Client.new config_file 

# retrieve all shop's items
data = c.all_pages :quiet do |page, per_page| 
  c.sell_shop_items page: page, per_page: per_page
end

puts MultiJson.dump data, :pretty => true

# shop_id == username
shop_id = c.username

data.each_with_index do |item, index|
  puts "shop: #{shop_id}, item: #{index+1}" 
  puts "            id: #{item["id"]}"
  puts "         title: #{item["title"]}"
  puts "      currency: #{item["currency"]}"
  puts "         price: #{item["price"]}"
  puts "original price: #{item["original_price"]}"  
  puts
end

puts "retrieving item: #{item_id}" 

# get item id details from server
item = c.sell_shop_item_find item_id

# save original price (blomming site discount logic visualization! )
item["original_price"] = item["price"]

# set discount of price
old_price = item["price"].to_f 
new_price = old_price.discount_percent percentage_of_discount

# save final price
item["price"] = new_price.to_s

puts "discounting item with new price: #{new_price}" 
puts "(original price: #{old_price}, discount percentage: #{percentage_of_discount}%)"

# save item on server
c.sell_shop_item_update item_id, item

puts "successfully discounted item: #{item_id}!" 
puts
