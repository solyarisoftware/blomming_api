#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint: items_search"
  puts "  usage: #{$0} <config_file.yml> <keyword>"
  puts "example: ruby #{$0} yourconfig.yml \"ambient music FLAC\"" 
  exit
end

config_file, keyword = ARGV

c = BlommingApi::Client.new config_file 

puts "searching items for keyword: \"#{keyword}\""

all_items = c.all_pages :stdout { |page, per_page|
  c.items_search( keyword, {page: page, per_page: per_page} )
} 

puts "#{all_items.size} items found for keyword: #{keyword}:" if all_items.any?

all_items.each_with_index { |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
}

puts "No items found for keyword: #{keyword}" unless all_items.any? 