#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoint: categories"
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

# set country local: ITALY
country = "it"

# initialize client (get token access by server authorization)
blomming = BlommingApi::Client.new config_file

# call API endpoint 
categories = blomming.categories locale: country

#
# list categories on stdout (name and relative internal category_id) 
# as a formatted table
# 
width_1 = (categories.collect { |item| item["name"].size }).max
width_2 = "category_id".size
puts "%-#{width_1}s | %-#{width_2}s" % ["category_name", "category_id"]
puts "#{'-'*(width_1+1)}+#{'-'*(width_2+1)}"

categories.each do |item| 

  category_name = item["name"]
  category_id = BlommingApi::PublicHelpers::id_from_name category_name, categories	
  puts "%-#{width_1}s | %-#{width_2}s" % [category_name, category_id]

end

# end of the table
puts "#{'-'*(width_1+1)}+#{'-'*(width_2+1)}"
