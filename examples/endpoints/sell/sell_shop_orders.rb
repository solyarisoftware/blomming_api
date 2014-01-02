#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil?
  puts "   goal: test endpoints: sell_shop_orders_states, sell_shop_orders"
  puts "  usage: #{$0} <config_file.yml>" 
  puts "example: ruby #{$0} config.yml"
  exit
end

config_file =  ARGV[0]

c = BlommingApi::Client.new(config_file)

# shop_id == username
shop_id = c.username

# retrieve all valid order states 
all_states = c.sell_shop_orders_states

puts "shop:" ; puts "#{shop_id}" ; puts

all_states.each do |state|

  puts "orders in state #{state}:"
  # retrieve all shop's orders with the specified status
  orders = c.all_pages (false) { |page, per_page| 
    c.sell_shop_orders state, {page: page, per_page: per_page}
  }

  if orders.size == 0
    puts "No orders found" ; puts
  else
    puts MultiJson.dump orders, :pretty => true
  end
end
