#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts " goal: test endpoints: sell_shop_sections*"	
  puts "usage: #{$0} <config_file.yml>"
  exit 
end

config_file =  ARGV[0]

blomming = BlommingApi::Client.new config_file

shop_id = blomming.username

#
# List Shop sections
#
sections = blomming.sell_shop_sections
#puts MultiJson.dump sections, :pretty => true

=begin
puts "Shop: #{shop_id} contain #{sections.size} sections:" 
sections.each do |section|  
  puts "name: #{section["name"]}, id: #{section["id"]}"  
end	

item_id =  651360
section_id = "CDR" # 41751
blomming.sell_shop_item_section_add item_id, section_id
=end


item_id =  651360
section_id = 35838 # "CDR"  
blomming.sell_shop_item_section_remove item_id, section_id


sections_names = BlommingApi::PublicHelpers::collect_key_values sections, "name" 
puts "Shop: #{shop_id} contain #{sections_names.size} sections:" 
puts "#{sections_names.nil? ? "WARNING: key 'sections' not found!" : sections_names.join(',')}"
puts

sections.each do |section|
  
  items = blomming.sell_shop_section_items section["id"]
  puts "Section: #{section["name"]} (id: #{section["id"]}) contain #{items.size} items:"
  
  items.each do |item|
    puts "  title: #{item["title"]}"    
  end
  puts	
end

=begin
new_section_name = "SUBLIME MUSICA ELETTRONICA"
new_section = blomming.sell_shop_section_create new_section_name
puts "Created new section, with name: #{new_section_name}, id: #{new_section["id"]})"


updated_section_name = "MUSICA ELETTRONICA"
updated_section = blomming.sell_shop_section_update new_section["id"], updated_section_name
puts "Created new section, with name: #{updated_section_name}, id: #{updated_section["id"]})"


#puts "sleep..."
#sleep (60*4)

deleted_section = blomming.sell_shop_section_delete new_section["id"]
puts "Deleted section, with id: #{updated_section["id"]})"

sections_names = BlommingApi::PublicHelpers::collect_key_values sections, "name" 
puts "Shop: #{shop_id} contain sections: #{sections_names.nil? ? "WARNING: key 'sections' not found!" : sections_names.join(',')}"
puts
=end