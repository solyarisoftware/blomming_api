#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

def show_details (item)

    # debug
	#puts MultiJson.dump item, :pretty => true

    puts "============================================="
	puts "              item_id: #{item["id"]}" 
    puts
	puts "                title: #{item["title"]}"
	puts "            published: #{item["published"]}"

	# truncate description: get first 71 chars of first line
	puts "          description: #{item["description"].lines.first[0, 70] unless item["description"].nil? || item["description"].empty?}" 

    utc_timestamp = item["created_at"]
    local_timestamp = BlommingApi::PublicHelpers::to_eurolocal utc_timestamp 
	puts "           created_at: #{local_timestamp} (#{utc_timestamp})" 

	puts "                price: #{item["price"]}"
	puts "       original_price: #{item["original_price"]}" 
	puts "             currency: #{item["currency"]}" 
	puts "               photos: #{item["photos"].join(',')}"
	puts "               photos: #{item["photos_id"].join(',')}"
	puts "             quantity: #{item["quantity"]}" 
 
	puts "              shop id: #{item["shop"]["id"]}"
	puts "            shop name: #{item["shop"]["name"]}"

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

	# Sections list
	sections = BlommingApi::PublicHelpers::collect_key_values item["sections"], "name" 
	puts "             sections: #{sections.nil? ? "WARNING: key 'sections' not found!" : sections.join(',')}"
	puts
	puts
end