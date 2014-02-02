#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

def show_details (item)

    # debug
	#puts MultiJson.dump item, :pretty => true

    puts
	puts "              item_id: #{item["id"]}" 
	puts "                title: #{item["title"]}"

	# truncate description: get first 71 chars of first line
	puts "          description: #{item["description"].lines.first[0, 70] unless item["description"].nil?}" 

    utc_timestamp = item["created_at"]
    local_timestamp = BlommingApi::PublicHelpers::to_eurolocal utc_timestamp 
	puts "           created_at: #{local_timestamp} (#{utc_timestamp})" 

	puts "                price: #{item["price"]}"
	puts "       original_price: #{item["original_price"]}" 
	puts "             currency: #{item["currency"]}" 
	puts "               photos: #{item["photos"].join(',')}"
	puts "             quantity: #{item["quantity"]}" 
	puts "              shop id: #{item["shop"]["id"]}"
	puts "            shop name: #{item["shop"]["name"]}"
	puts

	# SKUs list
	sku_ids = BlommingApi::PublicHelpers::collect_key_values item["skus"], "id"
	puts "            sku id(s): #{sku_ids.join ','}"
	puts

	# Shipping
	puts "  shipping profile id: #{item["shipping"]["profile_id"]}"
	puts "shipping profile name: #{item["shipping"]["profile_name"]}"
	puts "shipping ori. country: #{item["shipping"]["origin_country"]["name"]}"

	destination_countries = BlommingApi::PublicHelpers::collect_key_values item["shipping"]["destinations"], "name"
	puts "shipping destinations: #{destination_countries.join ','}"
	puts

	# Tags list
	tags = BlommingApi::PublicHelpers::collect_key_values item["tags"], "name"
	puts "                 tags: #{tags.join ','}"
	puts

	# Collections list
	# 4 January 2013. collections not yet available as item details (possible bug server side)
	collections = BlommingApi::PublicHelpers::collect_key_values item["collections"], "name" 
	puts "          collections: #{collections.nil? ? "WARNING: key 'collections' not found!" : collections.join(',')}"
	puts
end