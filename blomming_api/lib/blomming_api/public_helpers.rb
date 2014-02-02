# encoding: utf-8
require 'time'
require 'multi_json'
require 'rest_client'

module BlommingApi
  module PublicHelpers

    #
    # all_pages 
    # It's a Ruby block iterator that retrieve all items of all pages of any API endpoint.
    # 
    # === arguments
    #
    # +verbose+: :quite (silent mode)  
    #            :stdout (verbose mode: stdout puts)
    #
    # +per_page+: :number of items returned from a single page  
    #
    #
    # === examples
    #
    # all_pages(:stdout, 64) do |page, per_page| 
    #   client.shop_items(shop_id, {:page => page, :per_page => per_page}) 
    # end 
    # 
    # all_pages { |page, per_page| c.sell_shop_items page: page, per_page: per_page } 
    # 
    #
    def all_pages (verbose=:quite, per_page=16, &endpoint_call_block)
      page = 1
      data = []

      unless block_given? 
        raise 'method require a block! usage: #{__method__} '\
              '{ |page, per_page| endpoint_method(..., {page: page, per_page: per_page}) }'
      end  	

      print 'collecting all items from de-pagination ' if verbose==:stdout

      loop do
        print "." if verbose==:stdout

        # run block passing local variables: page, per_page.  
        data_single_page = endpoint_call_block.call page, per_page

        # debug
        # data_single_page.each_with_index { |item, index| 
        #  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}" }

        data.concat data_single_page 

        break if (data_single_page.size < per_page) || data_single_page.empty?
        page += 1
      end

      print "\n" if verbose==:stdout 
      data
    end

    def puts_response_header(method, data)   
      puts "#{method.to_s} response header_params:"
      puts data.header_params.to_s  
      puts
      puts "#{method.to_s} response data:"
      puts data
      puts
    end

    def dump_pretty (json_data)
      # JSON.pretty_generate(JSON.parse(json_data))
      puts MultiJson.dump json_data, :pretty => true 
    end


    #
    # class methods
    # 

    #
    # search in +data+ hash field +name+ and get value of corresponding 'id'
    # (per endpoint categories, collections) 
    #
    def self.id_from_name (name, data)
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

    #
    # collect key values associated to a key in +array+ of hashes
    # return nil if +array+ doesn't exist
    # return array containing a values list associated to +key_name+
    #
    def self.collect_key_values (array, key_name)
      return nil if array.nil?
      return array.collect { |item| item[key_name] }
    end

    #
    # TIME CONVERSIONS
    #

    #
    # Convert a timestamp in ISO 8601 format to Time
    #
    # example:
    #
    #   timestamp = '2014-01-14T15:17:42Z'
    #   to_time timestamp => 2014-01-14 15:17:42 UTC
    #
    def self.to_time (iso8601_timestamp)
      Time.iso8601(iso8601_timestamp)
    end 

    #
    # Print timestamp from Time in UTC
    # to local time in "European" timestamp format
    #
    # example:
    #
    #   time = 2014-01-14 15:17:42 UTC
    #   to_eurolocal_timestamp time => => '14-01-2014 16:17:42'
    #
    def self.to_eurolocal_timestamp (time)
      time.localtime if time.utc?   
      time.strftime "%d-%m-%Y %H:%M:%S"
    end 


    #
    # Convert a timestamp in ISO 8601 format to Time
    #
    # example:
    #
    #   timestamp = '2014-01-14T15:17:42Z'
    #   to_eurolocal timestamp => '14-01-2014 16:17:42'
    #
    def self.to_eurolocal (iso8601_timestamp)
      to_eurolocal_timestamp to_time iso8601_timestamp 
    end 
    
  end
end  	