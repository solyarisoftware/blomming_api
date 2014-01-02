#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoint: carts_create"
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

blomming = BlommingApi::Client.new config_file


#
# Add sku in a new cart:
#
# shop_id: solyarismusic
#   title: Discount Bundle 5 FLAC
#  itemid: 552087
#  sku_id: 608399
#

sku_id = 608399 #sku = { "sku_id" => 608399 }

data = blomming.carts_create sku_id

puts MultiJson.dump data, :pretty => true