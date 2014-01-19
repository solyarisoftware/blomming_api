#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint 'sell_shop_item_tags_add', 'sell_shop_item_tags_remove'"	
  puts "  usage: #{$0} <config_file.yml> <item id>"
  puts "example: ruby #{$0} $CONFIG 651360"
  exit 
end

config_file, item_id = ARGV

blomming = BlommingApi::Client.new config_file

tags = ["musica", "musica ambient", "musica elettronica", "ORA FUNZIONA!!!"]

puts "\nAdding to item: #{item_id} these tags:\n#{tags.join(',')}"
item = blomming.sell_shop_item_tags_add item_id, tags, {}

puts "\nRemoving from item: #{item_id} the tag:\n#{"ORA FUNZIONA!!!"}\n"
item = blomming.sell_shop_item_tags_remove item_id, "ORA FUNZIONA!!!", {}

puts MultiJson.dump item, :pretty => true
