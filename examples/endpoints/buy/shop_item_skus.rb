#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil? || ARGV[2].nil?
  puts "\ngoals:\n\tfor a specified shop id, show relation between an Item id and his SKU ids\n"
  puts "\nusage:\n\t#{$0} <config_file.yml> <shop_id> <item_id>\n"
  puts "\nexamples:"
  puts "\titem_ID <-> SKU_id: one-to-many:\n\t\truby #{$0} yourconfig.yml intimoasia 599802"
  puts "\titem_ID <-> SKU_id: one-to-one:\n\t\truby #{$0} yourconfig.yml solyarismusic 552087\n\n"
  exit
end   

config_file, shop_id, item_id = ARGV 

c = BlommingApi::Client.new config_file 

item = c.shops_item shop_id, item_id

#puts "JSON dump for item_id: #{item_id}, shop_id: #{shop_id}:"
#puts MultiJson.dump item, :pretty => true

title = item["title"]
quantity = item["quantity"]


puts "Shop:"
puts "#{shop_id}"; puts

puts "Item:"
puts "id: #{item_id}" ; puts "title: #{title}" ; puts "quantity: #{quantity}"; puts

puts "SKU (Stock Keeping Unit) id:"

skus = item["skus"]

skus.each_with_index do |sku, index|

  id = sku["id"] 
  barcode = sku["barcode"] 
  quantity = sku["quantity"] 

  puts "#{index+1}: id: #{id}, barcode: #{barcode}, quantity: #{quantity}" 

  properties = sku["props"]

  properties.each do |props|

    name = props["type"]["name"]
    id = props["type"]["id"]
    value = props["value"]

    puts "\tvalue: #{value} (name: #{name}, id: #{id})"

  end
end