#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoint: carts_*"
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

blomming = BlommingApi::Client.new config_file


#
# CREATE A NEW CART
#

# Add sku in a new cart:
#
# shop_id: solyarismusic
#   title: Discount Bundle 5 FLAC
#  itemid: 552087
#  sku_id: 608399
#
sku_id_toadd = 608399

# create a new cart
data = blomming.carts_create sku_id_toadd

# elaborate response
cart_id = data['id']
total_price = data['total_price']
currency = data['currency']

cart_sku = data['cart_skus'].first

sku_price = cart_sku['price']
sku_id = cart_sku['sku']['id']
sku_quantity = cart_sku['sku']['quantity']

item_id = cart_sku['sku']['item']['id']
item_title = cart_sku['sku']['item']['title']

puts "created new cart with id: #{cart_id} containing:"

puts "     sku_id: #{sku_id}"
puts "    item id: #{item_id}, title: #{item_title}, quantity: #{sku_quantity}"
puts "total price: #{total_price} #{currency}\n"


#
# ADD SKUS TO CART
# 

# Add two more skus to the created cart
# sku_id: 608394 => item_id: 552086 (title: Wanderer (flac) )
# sku_id: 608390  => item_id: 552082 (title: Ascension and Revelation (flac) )

data = blomming.carts_add(608394, 608390, cart_id, {})

#puts MultiJson.dump data, :pretty => true

puts "\nUpdated cart with id: #{cart_id} containing now two more items:\n\n"

cart_id = data['id']
total_price = data['total_price']
currency = data['currency']

cart_skus = data['cart_skus']

cart_skus.each_with_index do |cart_sku, index|
  sku_price = cart_sku['price']
  sku_id = cart_sku['sku']['id']
  sku_quantity = cart_sku['sku']['quantity']

  item_id = cart_sku['sku']['item']['id']
  item_title = cart_sku['sku']['item']['title']

  puts "  cart item: #{index+1}"
  puts "     sku_id: #{sku_id}"
  puts "    item id: #{item_id}, title: #{item_title}, quantity: #{sku_quantity}, price: #{sku_price}\n"
end

puts "\nTotal price: #{total_price} #{currency}"


#
# REMOVE SKUS FROM CART
# 
data = blomming.carts_remove(608394, 608390, cart_id, {})

puts "\nUpdated cart with id: #{cart_id} (removed two items previously added):\n\n"

cart_id = data['id']
total_price = data['total_price']
currency = data['currency']

cart_skus = data['cart_skus']

cart_skus.each_with_index do |cart_sku, index|
  sku_price = cart_sku['price']
  sku_id = cart_sku['sku']['id']
  sku_quantity = cart_sku['sku']['quantity']

  item_id = cart_sku['sku']['item']['id']
  item_title = cart_sku['sku']['item']['title']

  puts "  cart item: #{index+1}"
  puts "     sku_id: #{sku_id}"
  puts "    item id: #{item_id}, title: #{item_title}, quantity: #{sku_quantity}, price: #{sku_price}\n"
end

puts "\nTotal price: #{total_price} #{currency}"


#
# REMOVE ALL SKUS FROM CART
# 
data = blomming.carts_clear cart_id

puts MultiJson.dump data, :pretty => true

puts "\nCleared cart with id: #{cart_id}."
