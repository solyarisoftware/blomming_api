#!/bin/env ruby
# encoding: utf-8
require 'trollop'
require 'blomming_api'

#
# command line arguments and options
#
opts = Trollop::options do
  version "#{$0} (Blommimg API Endpoint Simple Tester) v.#{BlommingApi::VERSION} by giorgio.robino@gmail.com"
  banner <<-EOS

#{version}

Usage:

  ruby #{$0} <config_file.yml> <api_endpoint> [<parameters>]


BLOMMING API Endpoint list and parameters: 

BUY

  categories/index
  categories/items <category_id>

  collections/index
  collections/items <collection_id>

  countries

  items/discounted
  items/featured
  items/hand_picked
  items/list <item_id>
  items/most_liked
  items/search <keyword>

  provinces/show <province_id>

  shops/index
  shops/items <shop_id>
  shops/item  <shop_id> <item_id>
  shops/show  <shop_id>

  tags/index
  tags/items <tag_id>

  oauth_token

Usage examples:

  ruby #{$0} config.yml items/search "musica ambient"
  ruby #{$0} config.yml shops/items solyarismusic
  ruby #{$0} config.yml shops/item solyarismusic 552087
  ruby #{$0} config.yml tags/items musica

EOS

#  opt :pretty_json, "pretty printed JSON instead of minified received data", :default => true, :short => "-p"
end

#
# MAIN
#

# command line parameter per file di configurazione
config_file = ARGV[0]

# command line parameter per API richiesta
endpoint = ARGV[1]

Trollop::die "argument <config_file> not found" if ARGV.empty?
Trollop::die "config_file #{config_file} must exist" unless File.exist?(config_file) if config_file
Trollop::die "argument <endpoint> not found" unless endpoint

  
# crea istanza di client
c = BlommingApi::Client.new config_file


case endpoint
  when "token"
    c.pretty_puts c.token

  #
  # BUY
  #
  when "categories/index"
    c.pretty_puts c.categories_index

  when "categories/items"
  	category_id = ARGV[2]
    Trollop::die "argument <category_id> not found" unless category_id
    c.pretty_puts c.categories_items category_id

  when "collections/index"
    c.pretty_puts c.collections_index

  when "collections/items"
  	collections_id = ARGV[2]    
    Trollop::die "argument <collection_id> not found" unless collections_id
    c.pretty_puts c.collections_items collections_id

  when "provinces/show"
    province_id = ARGV[2]
    Trollop::die "argument <province_id> not found" unless province_id
    c.pretty_puts c.provinces_show province_id

  when "countries"
    c.pretty_puts c.provinces

  when "items/discounted"
    c.pretty_puts c.items_discounted

  when "items/featured"
    c.pretty_puts c.items_featured

  when "items/hand_picked"
    c.pretty_puts c.items_hand_picked

  when "items/list"
    item_id = ARGV[2]    
    Trollop::die "argument <item_id> not found" unless item_id
    c.pretty_puts c.items_list item_id

  when "items/most_liked"
    c.pretty_puts c.items_most_liked

  when "items/search"
    keyword = ARGV[2]    
    Trollop::die "argument <keyword> not found" unless keyword
    c.pretty_puts c.items_search keyword

  when "shops/index"
    c.pretty_puts c.shops_index

  when "shops/items"
  	shop_id = ARGV[2]
    Trollop::die "argument <shop_id> not found" unless shop_id
    c.pretty_puts c.shops_items shop_id

  when "shops/item"
    shop_id = ARGV[2]
    item_id = ARGV[3]
    Trollop::die "argument <shop_id> not found" unless shop_id
    Trollop::die "argument <item_id> not found" unless item_id
    c.pretty_puts c.shops_item shop_id, item_id

  when "shops/show"
    shop_id = ARGV[2]
    Trollop::die "argument <shop_id> not found" unless shop_id
    c.pretty_puts c.shops_show shop_id

  when "tags/index"
    c.pretty_puts c.tags_index

  when "tags/items"
    tag_id = ARGV[2]
    Trollop::die "argument <tag_id> not found" unless tag_id
    c.pretty_puts c.tags_items tag_id

  #
  # SELL
  #
  when "sell/shops/items"
    shop_id = ARGV[2]
    Trollop::die "argument <shop_id> not found" unless shop_id
    c.pretty_puts bac.sell_shops_items shop_id

  else
    Trollop::die "#{endpoint}: unknown endpoint"
end

=begin
def pp (json, pretty_puts=true)
   pretty_puts ? ( c.pretty_puts (json) ) : ( puts json )
end  
=end