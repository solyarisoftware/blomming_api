#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "usage: #{$0} <config_file.yml> <category_name>" 
  puts "example: ruby #{$0} ./config/yourconfig.yml \"Casa:Giardino & Outdoor\""
  exit
else
  config_file = ARGV[0]
  category_name = ARGV[1]
end

c = BlommingApi::Client.new config_file 

# prende tutti i nomi delle categorie blomming
categories_data = MultiJson.load c.categories_index

# ottiene l'id associato a nome categoria (stringa)
category_id = c.id_from_name category_name, categories_data

unless category_id
  puts "category name: #{category_name} not found among Blomming categories"
  exit
else
  puts "searching items for category name: \"#{category_name}\" (category_id: #{category_id})"
end	

# estrae tutti gli items associati al category_id
data = c.all_pages (true) { |page, per_page| c.categories_items( category_id, {:page => page, :per_page => per_page} ) } 

data.each_with_index { |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
}