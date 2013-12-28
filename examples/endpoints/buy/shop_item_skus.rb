#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil? || ARGV[2].nil?
  puts "usage: #{$0} <config_file.yml> <shop_id> <item_id>\n"
  puts "example: ruby #{$0} ./config/yourconfig.yml intimoasia 599802"
  exit
end   

config_file = ARGV[0]
shop_id = ARGV[1]

item_id = ARGV[2]

c = BlommingApi::Client.new config_file 

item = c.shops_item shop_id, item_id

#puts "JSON dump for item_id: #{item_id}, shop_id: #{shop_id}:"
#puts MultiJson.dump item, :pretty => true

title = item["title"]
quantity = item["quantity"]


puts "Shop:"
puts "#{shop_id}"
puts

puts "Item:"
puts "id: #{item_id}, title: #{title}, quantity: #{quantity}"
puts

puts "SKU (Stock Keeping Unit):"

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

    puts "value: #{value} (name: #{name}, id: #{id})"

  end
end