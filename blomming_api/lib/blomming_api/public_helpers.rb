# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module PublicHelpers

    #
    # all_pages 
    # It's a Ruby block iterator that retrieve all items of all pages of any API endpoint.
    # Usage example:
    # all_pages { |page, per_page| 
    #   client.shops_items(shop_id, {:page => page, :per_page => per_page}) 
    # } 
    #
    def all_pages (stdout_verbose=true, per_page=16, &endpoint_call_block)
      page = 1
      data = []

      unless block_given? 
        raise 'method require a block! usage: #{__method__} '\
              '{ |page, per_page| endpoint_method(..., {page: page, per_page: per_page}) }'
      end  	

      print 'collecting items from pages ' if stdout_verbose

      loop do
        print "." if stdout_verbose

        # run block passing local variables: page, per_page.  
        data_single_page = endpoint_call_block.call page, per_page

        # debug
        # data_single_page.each_with_index { |item, index| 
        #  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}" }

        data.concat data_single_page 

        break if (data_single_page.size < per_page) || data_single_page.empty?
        page += 1
      end

      print "\n" if stdout_verbose 
      data
    end

    #
    # cerca nell'hash 'data' il campo 'name' ed estrae corrispondente 'id'
    # per endpoint categories, collections 
    #
    def id_from_name (name, data)
      id = nil
      data.each  { |item|
        if name == item["name"]
          # estrae l'id dal campo: items_url.
          id = item["items_url"].split('/')[-2]   # scan( /\d+/ ).last
          break
        end  
      }
      id
    end

    def puts_response_header(method, data)   
      puts "#{method.to_s} response header_params:"
      puts data.header_params.to_s  
      puts
      puts "#{method.to_s} response data:"
      puts data
      puts
    end

    def puts_url(url)
      puts "url:"
      puts url
      puts
    end

    def dump_pretty (json_data)
      # JSON.pretty_generate(JSON.parse(json_data))
      puts MultiJson.dump json_data, :pretty => true 
    end

  end
end  	