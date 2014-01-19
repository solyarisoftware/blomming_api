#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoints: sell_shipping_profile*"	
  puts "usage: #{$0} <config_file.yml>"
  puts "example: ruby #{$0} $CONFIG"
  exit 
end

config_file =  ARGV[0]

blomming = BlommingApi::Client.new config_file

puts "your shop id: #{blomming.username}" 


# CREATE A NEW SHIPPING PROFILE 
new_shipping_profile = { 
  "name" => "Spedizione di test", 
  "origin_country_code" => "IT", 
  "everywhere_else_cost_single" => 4, 
  "everywhere_else_cost_shared" => 3 
}

puts new_shipping_profile

shipping_profile = blomming.sell_shipping_profile_create new_shipping_profile

puts MultiJson.dump shipping_profile, :pretty => true

id = shipping_profile["id"]

# READ shipping profile
#
# name: Standard Postal Service ("Posta Prioritaria")
#   id: 711224
#
shipping_profile = blomming.sell_shipping_profile_find id 

puts MultiJson.dump shipping_profile, :pretty => true
