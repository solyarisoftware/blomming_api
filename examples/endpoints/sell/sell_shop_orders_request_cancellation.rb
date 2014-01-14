#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'


if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint 'sell_shop_orders_request_cancellation'"	
  puts "  usage: #{$0} <config_file.yml> <order_number>"
  puts "example: ruby #{$0} yourconfig.yml b4c9ce67e366852e"
  exit 
end

config_file, order_number = ARGV

blomming = BlommingApi::Client.new config_file

order = blomming.sell_shop_orders_find order_number

puts "\nOrder: #{order_number} now in state: #{order["current_state"]}"

reason_string = "Hi Blomming staff! Please cancel order ##{order_number}: \
it's a blommig_api test by your preferred beta tester (giorgio.robino@gmail.com)!"

order = blomming.sell_shop_orders_request_cancellation order_number, reason_string

puts "\nCancellation request for order: #{order_number} submitted!"
