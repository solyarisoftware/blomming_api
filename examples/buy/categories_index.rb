#!/bin/env ruby
# encoding: utf-8
require 'blomming_api'

if ARGV.empty?
  puts "usage: #{$0} <config_file.yml>" 
  exit
else
  config_file =  ARGV[0]
end

country = "it"

# prende tutte le categorie blomming
data = MultiJson.load BlommingApi::Client.new(config_file).categories_index ( {:locale => country} )

# stampa su stdout l'elenco delle macrocategorie Blomming
data.each { |item| puts item["name"] }
