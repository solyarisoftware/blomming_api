#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil? 
  puts "usage: #{$0} <config_file.yml> <keyword>"
  puts "example: ruby #{$0} yourconfig.yml \"ambient music FLAC\"" 
  exit
end

config_file = ARGV[0]
keyword = ARGV[1]

c = BlommingApi::Client.new config_file 

puts "searching items for keyword: \"#{keyword}\""

data = c.all_pages (true) { |page, per_page| c.items_search( keyword, {:page => page, :per_page => per_page} ) } 

data.each_with_index { |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
}