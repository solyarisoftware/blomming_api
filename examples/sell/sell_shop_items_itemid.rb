#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts "usage: #{$0} <config_file.yml>" 
  exit
end

config_file =  ARGV[0]
shop_id = "solyarismusic"

 c = BlommingApi::Client.new(config_file)

#puts c.inspect

# list shop's items
puts "shop: #{shop_id}, items:" 
data = c.all_pages (true) { |page, per_page| c.sell_shop_items shop_id }
data.each_with_index { |item, index| puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}" }

#
# CRUD = CREATE, READ, UPDATE, DELETE
#

# CREATE NEW ITEM
new_item_json =
'{
  "category_id": "48",
  "user_id": "solyarismusic",
  "source_shipping_profile_id": "1",
  "price": 18.99,
  "title": "New item for test. title",
  "quantity": 1,
  "description": "New item for test. description",
  "published": false,
  "async_contents": ["http://solyaris4.altervista.org/solyarismusic_test_image.jpg"]
}'

# new item as object
new_item = MultiJson.load(new_item_json)

puts; puts "new item:"; puts new_item

# create item passing JSON payload
json_response = c.sell_shop_items_create new_item_json

# get item ID from response 
item_id = MultiJson.load(json_response)["id"]
puts "shop: #{shop_id}, created item with id: #{item_id}"


# UPDATE ITEM
# update item as object
updated_item = new_item.merge({ "quantity" => 10 })

# Update item passing JSON payload
updated_item_json = MultiJson.dump updated_item

c.sell_shop_items_update item_id, updated_item_json
puts "shop: #{shop_id}, updated item with id: #{item_id}"


# READ ITEM
json = c.sell_shop_items_read item_id

# get updated quantity
updated_quantity = MultiJson.load(json)["quantity"]
puts "shop: #{shop_id}, read item with id: #{item_id}, (updated quantity value: #{updated_quantity})"
#c.pretty_puts json

# DELETE ITEM
data = MultiJson.load c.sell_shop_items_delete item_id
puts "deleted item with id: #{item_id}"