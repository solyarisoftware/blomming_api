#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "usage: #{$0} <config_file.yml> <shop_id>" 
  puts "example: ruby #{$0} config.yml solyarismusic"
  exit
end

config_file =  ARGV[0]
shop_id = ARGV[1]

c = BlommingApi::Client.new(config_file)

# retrieve all valid order states 
all_states = c.sell_shop_orders_states

puts "shop" ; puts "#{shop_id}" ; puts

all_states.each { |state|

  puts "orders in state: #{state}"
  # retrieve all shop's orders with the specified status
  orders = c.all_pages(false) { |page, per_page| 
    c.sell_shop_orders shop_id, state
  }

  if orders.size == 0
    puts "No orders found" ; puts
  else
    puts MultiJson.dump orders, :pretty => true
  end
}

