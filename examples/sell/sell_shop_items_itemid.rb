#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts "usage: #{$0} <config_file.yml>" 
  exit
else
  config_file =  ARGV[0]
end

shop_id = "solyarismusic"

# prende tutte le categorie blomming
 c = BlommingApi::Client.new(config_file)

puts c.inspect

# elenca gli items dello shop
puts "shop: #{shop_id}, contains items:" 
data = c.all_pages (true) { |page, per_page| c.sell_shop_items shop_id }
data.each_with_index { |item, index| puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}" }

# deve generare eccezione
#data = MultiJson.load c.sell_shop_items_itemid(:getta, shop_id, "552087")

#
# CRUD: CREATE,READ, UPDATE, DELETE
#

# CREATE NEW ITEM
new_item_json =
'{
  "category_id": "48",
  "user_id": "solyarismusic",
  "source_shipping_profile_id": "1",
  "price": 69.00,
  "title": "new item title",
  "quantity": 1,
  "description": "new item description",
  "published": false,
  "async_contents": ["http://solyaris4.altervista.org/michelecesareo/1_borsa/img.jpg"]
}'

new_item = MultiJson.load(new_item_json)

puts "new item:"
puts new_item

json = c.sell_shop_items_itemid(:create, shop_id, nil, new_item )

item_id = MultiJson.load(json)["id"]
puts "shop: #{shop_id}, created item with id: #{item_id}"

# UPDATE ITEM
data = MultiJson.load c.sell_shop_items_itemid(:update, shop_id, item_id, { "quantity" => 10 } )
puts "shop: #{shop_id}, updated item with id: #{item_id}"

# READ ITEM
json = c.sell_shop_items_itemid(:get, shop_id, item_id)

updated_quantity = MultiJson.load(json)["quantity"]

puts "shop: #{shop_id}, read item with id: #{item_id}, updated quantity: #{updated_quantity}"

# stampa json
#c.pretty_puts json

# DELETE ITEM
data = MultiJson.load c.sell_shop_items_itemid(:delete, shop_id, item_id)
puts "deleted item with id: #{item_id}"
