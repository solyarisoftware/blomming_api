#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'


if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint 'sell_shop_orders_find'"	
  puts "  usage: #{$0} <config_file.yml> <order_number>"
  puts "example: ruby #{$0} $CONFIG b4c9ce67e366852e"
  exit 
end

config_file, order_number = ARGV

blomming = BlommingApi::Client.new config_file

order = blomming.sell_shop_orders_find order_number

#puts MultiJson.dump order, :pretty => true

puts "\n       Order: #{order_number}" 
puts "       State: #{order["current_state"]}"

utc_timestamp = order["date"]
local_timestamp = BlommingApi::PublicHelpers::to_eurolocal utc_timestamp 

puts "        Date: #{local_timestamp} (#{utc_timestamp})"

puts "     Payment: #{order["payment_type"]}"
puts "      Locale: #{order["locale"]}"

num_products = order["num_products"]

puts "Products Nr.: #{num_products}"
puts " Total price: #{order["price"]} #{order["currency_code"]}"

puts "\nProduct#{ (num_products > 1) ? 's': '' } details:" 

products = order["products_details"]

products.each do |product|

  puts "\n    name: #{product["name"]}"
  puts "   price: #{product["price"]}"
  puts "quantity: #{product["quantity"]}\n"

end	

first_name = order["billing_address"]["first_name"]
last_name = order["billing_address"]["last_name"]
street = order["billing_address"]["street"]
postal_code = order["billing_address"]["postal_code"]
city = order["billing_address"]["city"]
province = order["billing_address"]["province"]
country = order["billing_address"]["country"]
email = order["contact_details"]["email"]
phone = order["contact_details"]["phone"]

puts "\nBilling details:"
puts
puts "      To: #{first_name} #{last_name}"
puts " Address: #{street}, #{postal_code}, #{city} (#{province}), #{country}"

puts "\nContact details:"
puts
puts "   email: #{email}"
puts "   phone: #{phone}"
puts

=begin
state = "closed"
order = blomming.sell_shop_orders_change_state order_number, state

puts "\nOrder: #{order_number} now in state: '#{state}'!"
=end
