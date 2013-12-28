#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'


if ARGV[0].nil? || ARGV[1].nil?
  puts "  usage: ruby #{$0} yourconfig.yml <collection_name>" 
  puts "example: ruby #{$0} yourconfig.yml \"Regali sotto 50 € \"" 
  exit
end

config_file = ARGV[0]
collection_name = ARGV[1]

c = BlommingApi::Client.new config_file 

# retrieve all collections blomming names
puts "get blomming collections"
collections = c.all_pages { |page| 
  c.collections( {page: page} )
} 

#data = c.collections_index( {:page => 2} ) 
#c.dump_pretty data
#puts data.size
puts MultiJson.dump collections, :pretty => true


# get collection_id value (integer) associated to a collection_name (string)
collection_id = c.id_from_name collection_name, collections

unless collection_id
  puts "collection name: #{collection_name} not found among blomming collections"
  exit
else
  puts "searching items for collection name: #{collection_name} (collection_id: #{collection_id})"
end	

# retrieve all items associated with a collection_id
all_items = c.all_pages { |page, per_page|
  c.collections_items( collection_id, {page: page, per_page: per_page} )
} 

# print to stdout for each item these fields: title, item_id, shop_id 
all_items.each_with_index { |item, index|
	
  item_title = item["title"] 
  item_id = item["id"]
  shop_id = item["shop"]["id"]

  puts "#{index+1}: title: #{item_title}, id: #{item_id}, shop: #{shop_id}"
}