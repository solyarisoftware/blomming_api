#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoints: tags, tags_items"
  puts "  usage: #{$0} <config_file.yml> <tags_name>" 
  puts "example: ruby #{$0} ./config/yourconfig.yml \"musica ambient\""
  exit
end

config_file = ARGV[0]
tag_name = ARGV[1]

c = BlommingApi::Client.new config_file 

# retrieve blomming tags
tags = c.tags

#puts MultiJson.dump tags, :pretty => false 

puts "possible related tags (amongs #{tags.size}):"
tags.each { |item, index|
  unless (item["name"].downcase =~ /#{tag_name.downcase.split.join '|'}/).nil?
    puts "tag name: #{item["name"]}"
  end  
}
puts

# retrieve tag id (numeric) associated to a tag name (string)
tag_id = BlommingApi::PublicHelpers::id_from_name tag_name, tags

unless tag_id
  puts "tag name: '#{tag_name}' not found among Blomming tags"
  exit
else
  puts "searching items for tag name: \"#{tag_name}\" (tag_id: #{tag_id})"
end	

# retrieve all items associated to specific tag_id
all_items = c.all_pages (:stdout) { |page, per_page|
  c.tags_items( tag_id, {:page => page, :per_page => per_page} )
} 

# print to stdout for each item these fields: title, item_id, shop_id 
all_items.each_with_index { |item, index|

  item_title = item["title"] 
  item_id = item["id"]
  shop_id = item["shop"]["id"]

  puts "#{index+1}: title: #{item_title}, id: #{item_id}, shop: #{shop_id}"
}
