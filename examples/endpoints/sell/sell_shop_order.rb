#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'


if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint 'sell_shop_orders_find'"	
  puts "  usage: #{$0} <config_file.yml> <order_number>"
  puts "example: ruby #{$0} yourconfig.yml b4c9ce67e366852e"
  exit 
end

config_file, order_number = ARGV

blomming = BlommingApi::Client.new config_file

order = blomming.sell_shop_orders_find order_number

#puts MultiJson.dump order, :pretty => true

puts "\nOrder: #{order_number}" 
puts "State: #{order["current_state"]}"

products = order["products_details"]

puts "\nItems in order:" 

products.each do |product|

  puts "\n    name: #{product["name"]}"
  puts "   price: #{product["price"]}"
  puts "quantity: #{product["quantity"]}\n"

end	

puts "\nTotal price: #{order["price"]} #{order["currency_code"]}"

puts "\nBilling details:"
puts "To: #{order["billing_address"]["first_name"]} #{order["billing_address"]["last_name"]}"
puts "Address: #{order["billing_address"]["street"]}, \
#{order["billing_address"]["postal_code"]}, \
#{order["billing_address"]["city"]} \
(#{order["billing_address"]["province"]}), \
#{order["billing_address"]["country"]}"

puts "\nContact details:"
puts "email: #{order["contact_details"]["email"]}"
puts "phone: #{order["contact_details"]["phone"]}"

=begin
state = "closed"
order = blomming.sell_shop_orders_change_state order_number, state

puts "\nOrder: #{order_number} now in state: '#{state}'!"
=end
