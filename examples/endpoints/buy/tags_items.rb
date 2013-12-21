#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "usage: #{$0} <config_file.yml> <tags_name>" 
  puts "example: ruby #{$0} ./config/yourconfig.yml \"musica ambient\""
  exit
end

config_file = ARGV[0]
tag_name = ARGV[1]

c = BlommingApi::Client.new config_file 

# prende tutti i blomming tags
tags_data = c.tags_index

tags_data.each_with_index { |item, index| puts "#{index+1}: name: #{item["name"]}" }

#puts MultiJson.dump tags_data, :pretty => false 
#puts tags_data.size

=begin
# ottiene l'id associato a nome categoria (stringa)
tag_id = c.id_from_name tag_name, tags_data

unless tag_id
  puts "tag name: #{tag_name} not found among Blomming tags"
  exit
else
  puts "searching items for tag name: \"#{tag_name}\" (tag_id: #{tag_id})"
end	

# estrae tutti gli items associati al tag_id
data = c.all_pages (true) { |page, per_page| c.tags_items( tag_id, {:page => page, :per_page => per_page} ) } 

data.each_with_index { |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
}
=end