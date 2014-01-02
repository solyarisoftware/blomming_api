#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoints: sell_shop_user_details"	
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

blomming = BlommingApi::Client.new config_file

puts "your username: #{blomming.username}" 

user_details = blomming.sell_shop_user_details

#puts MultiJson.dump user_details, :pretty => true

puts "your shop id: #{user_details["id"]}" 
puts "your shop name: #{user_details["name"]}" 