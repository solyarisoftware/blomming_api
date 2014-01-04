#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'
require './discounts_helper'

if ARGV[0].nil? || ARGV[1].nil? || ARGV[2].nil?
  puts "   goal: discount price for a specified set of items on the shop\n"
  puts "  usage: #{$0} <config_file.yml> <discount_percentage> [<item_id>]" 
  puts "example:ruby #{$0} solyarismusic.yml 10% 540268 540266"
  exit
end

config_file, percentage_of_discount = ARGV

ARGV.shift 2

# get array of item ids from command line
item_id_list = ARGV

c = BlommingApi::Client.new config_file 

# retrieve all shop's items
data = c.all_pages :quiet do |page, per_page| 
  c.sell_shop_items page: page, per_page: per_page
end

# shop_id == username
shop_id = c.username

puts "items to be discounted for shop '#{shop_id}':" 

data.each do |item|
  if item_id_list.include? item["id"]
    puts "            id: #{item["id"]}"
    puts "         title: #{item["title"]}"
    puts "      currency: #{item["currency"]}"
    puts "         price: #{item["price"]}"
    puts "original price: #{item["original_price"]}"  
    puts
  end  
end

item_id_list.each do |item_id|
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
  puts "(original price: #{old_price}, discount percentage: #{percentage_of_discount})"

  # save item on server
  c.sell_shop_item_update item_id, item

  puts "successfully discounted item: #{item_id}!" 
  puts
end