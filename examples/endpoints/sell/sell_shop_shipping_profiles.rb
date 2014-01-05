#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoints: sell_shipping_profiles"	
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

blomming = BlommingApi::Client.new config_file

puts "shop: #{blomming.username}" 
puts

shipping_profiles = blomming.sell_shop_shipping_profiles

#puts MultiJson.dump profiles, :pretty => true

# list name and id of all shopping profiles 
shipping_profiles.each do |profile|
	puts "name: #{profile["name"]}"
	puts "  id: #{profile["id"]}"
	puts
end	
