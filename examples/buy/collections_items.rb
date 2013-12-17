#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'


if ARGV.empty?
  puts "usage: #{$0} <config_file.yml> <collection_name>" 
  exit
end

config_file = ARGV[0]
collection_name = ARGV[1]

c = BlommingApi::Client.new config_file 

# prende tutti i nomi delle collections blomming
puts "get blomming collections"
data = c.all_pages (true) { |page| c.collections_index( {:page => page} ) } 
#data = c.collections_index( {:page => 2} ) 
#c.pretty_puts data
#puts data.size
puts MultiJson.dump data, :pretty => true

# MultiJson.load  

=begin
# ottiene l'id associato a nome collezione (stringa)
collection_id = item_id collection_name, data

unless collection_id
  puts "collection name: #{collection_name} not found among blomming collections"
  exit
else
  puts "searching items for collection name: #{collection_name} (collection_id: #{collection_id})"
end	

# estrae tutti gli items associati al collection_id
data = c.all_pages (true) { |page, per_page| c.collections_items( collection_id, {:page => page, :per_page => per_page} ) } 

data.each_with_index { |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
}
=end
