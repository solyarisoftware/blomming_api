#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'


if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint: collections, collection_items"
  puts "  usage: ruby #{$0} yourconfig.yml <collection_name>" 
  puts "example: ruby #{$0} yourconfig.yml \"Bambole e Pupazzi\"" 
  exit
end

config_file = ARGV[0]
collection_name = ARGV[1]

c = BlommingApi::Client.new config_file 

# retrieve all collections blomming names
puts "get blomming collections"
collections = c.all_pages :stdout { |page| c.collections page: page } 

#puts MultiJson.dump collections, :pretty => true
collections.each_with_index { |item, index| puts "#{index+1}: #{item["name"]}" }

# get collection_id value (integer) associated to a collection_name (string)
collection_id = BlommingApi::PublicHelpers::id_from_name collection_name, collections

unless collection_id
  puts "collection name: #{collection_name} not found among blomming collections"
  exit
else
  puts "searching items for collection name: #{collection_name} (collection_id: #{collection_id})"
end	

# retrieve all items associated with a collection_id
all_items = c.all_pages :stdout { |page, per_page|
  c.collection_items( collection_id, {page: page, per_page: per_page} )
}

# print to stdout for each item these fields: title, item_id, shop_id 
all_items.each_with_index { |item, index|
	
  item_title = item["title"] 
  item_id = item["id"]
  shop_id = item["shop"]["id"]

  puts "#{index+1}: title: #{item_title}, id: #{item_id}, shop: #{shop_id}"
}