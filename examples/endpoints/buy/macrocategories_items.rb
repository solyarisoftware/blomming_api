#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV[0].nil? || ARGV[1].nil?
  puts "   goal: test endpoint: macrocategories"
  puts "  usage: #{$0} <config_file.yml> <macrocategory_name>" 
  puts "example: ruby #{$0} config.yml Casa"
  exit
end

config_file = ARGV[0]
macrocategory_name = ARGV[1]

c = BlommingApi::Client.new config_file 

# retrieve all blomming macrocategories names 
macrocategories = c.macrocategories

puts MultiJson.dump macrocategories, :pretty => true

=begin
# get id (numeric identificator) associated to a certain macrocategory name (string identificator)
macrocategory_id = BlommingApi::PublicHelpers::id_from_name macrocategory_name, macrocategories

unless macrocategory_id
  puts "macrocategory name: #{macrocategory_name} not found among Blomming macrocategories"
  exit
else
  puts "searching items for macrocategory name: \"#{macrocategory_name}\" (macrocategory_id: #{macrocategory_id})"
end	

# retrieve all items data associated to a macrocategory
all_items = c.all_pages :stdout do |page, per_page| 
  c.macrocategory_items( macrocategory_id, {page: page, per_page: per_page} )
end   

# for each item: print on stdout a subset of data fields (item title, item id, shop id)
all_items.each_with_index do |item, index| 
  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}"
end
=end