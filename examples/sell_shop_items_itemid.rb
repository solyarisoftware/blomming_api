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

# deve generare eccezione
data = MultiJson.load c.sell_shop_items_item(:getta, shop_id, "552087")

#
# CRUD: CREATE,READ, UPDATE, DELETE
#

# CREATE NEW ITEM
json = c.sell_shop_items_item(:create, shop_id, nil,
  {
  "category_id": "48", # musica
  "user_id": "solyarismusic",
  "source_shipping_profile_id": "1",
  "price": 69.00,
  "title": "new item title",
  "quantity": 1,
  "description": "new item description",
  "published": false,
  "async_contents": ["http://solyaris4.altervista.org/michelecesareo/1_borsa/img.jpg"]
} )

item_id = MultiJson.load(json)["id"]
puts "created item with id: #{item_id}"

# UPDATE ITEM
data = MultiJson.load c.sell_shop_items_item(:update, shop_id, item_id, { "quantity": 10 } )
puts "updated item with id: #{item_id}"

# READ ITEM
json = c.sell_shop_items_item(:get, shop_id, item_id)

updated_quantity = MultiJson.load(json)["quantity"]

puts "read item with id: #{item_id}, quantity: #{updated_quantity}"

# stampa json
#c.pretty_puts json

# DELETE ITEM
data = MultiJson.load c.sell_shop_items_item(:delete, shop_id, item_id)
puts "deleted item with id: #{item_id}"
