#!/bin/env ruby
# encoding: utf-8

def csv_template(col_sep, encoding='utf-8')
  #"sku;img;img1;img2;img3;title;description;quantity;price;original_price;shipping_profile;category;tags;collections;published"
  "id#{col_sep}title#{col_sep}description#{col_sep}created_at#{col_sep}price#{col_sep}original_price#{col_sep}photo1#{col_sep}photo2#{col_sep}photo3#{col_sep}photo4#{col_sep}quantity\n"
end


def csv_addrow (item, index, col_sep, text_quote, debug=false, encoding='utf-8')
  # splitto l'arrays contenente le foto (max 4) in quattro campi.
  photo1, photo2, photo3, photo4 = item["photos"]

  # cambia doppie virgolette in singole
  if text_quote == '"'
    description = item["description"].gsub(text_quote, "'") 
  else
    description = item["description"]
  end  

  # to_s per convertire in "" eventuali valori nil
  row = item["id"].to_s + col_sep +

        text_quote + item["title"].to_s + text_quote + col_sep +
        text_quote + description.to_s + text_quote + col_sep +

        item["created_at"].to_s + col_sep +        
        item["price"].to_s + col_sep +
        item["original_price"].to_s + col_sep +
  
        photo1.to_s + col_sep +
        photo2.to_s + col_sep +
        photo3.to_s + col_sep +
        photo4.to_s + col_sep +
        item["quantity"].to_s +
        "\n"

  puts "row #{index+1}: id: #{item["id"]}, title: #{item["title"]}"  if debug # #{__method__}: 

  # row
  row.encode("utf-8", "utf-8", :invalid => :replace).force_encoding("utf-8")
end

def csv_create (filename, col_sep)
  File.open(filename, 'w:utf-8') { |f| f.write csv_template col_sep }
end

def csv_update (filename, item, index, col_sep, text_quote, debug=false)
  File.open(filename, 'a') { |f| f.write csv_addrow item, index, col_sep, text_quote, debug }
end