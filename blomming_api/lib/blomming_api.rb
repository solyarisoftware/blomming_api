# encoding: utf-8
require 'yaml'
require 'multi_json'
require 'rest_client' # https://github.com/rest-client/rest-client

require "blomming_api/version"

module BlommingApi
  #
  # CLIENT ACCESS LOGIC
  #
  class Client 

  def initialize(config_filename)
    # read YAML configuration file
    read_config_file(config_filename)  

    # authenticate!
    @access_token = oauth_token   
  end


  def read_config_file(config_filename)
    config = YAML.load_file(config_filename)
    #STDOUT.puts config.inspect
  
    @client_app_description  = config['client_app_description']

    @grant_type  = config['grant_type']
  
    @username  = config['username']
    @password  = config['password']
  
    @client_id  = config['client_id']
    @client_secret  = config['client_secret']
  
    @domain  = config['domain']
    @api_version  = config['api_version']

    @currency = config['default_currency']
    @locale = config['default_locale']

    @verbose = config['verbose']

    @verbose_access_token = @verbose

    puts_config(config_filename) if @verbose
  end


  def pretty_puts (json_data)
    puts MultiJson.dump json_data, :pretty => true # JSON.pretty_generate(JSON.parse(json_data))
  end  

  def puts_config (config_file)
    puts "config parameters on #{config_file}:"  
    puts "client_app_description: " + @client_app_description  
    puts "grant_type: " + @grant_type
    puts "username: " + @username
    puts "password: " + @password
    puts "client_id: " + @client_id
    puts "client_secret: " + @client_secret
    puts "domain: " + @domain
    puts "default_currency: " + @currency
    puts "default_locale: " + @locale
    puts
  end

  def puts_access_token(access_token)   
    puts "access_token:"
    puts access_token
    puts
  end

  def puts_response_header(method, data)   
    puts "#{method.to_s} response headers:"
    puts data.headers.to_s  
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

  #
  # helper: manage RestClient exceptions. iterator.  
  #
  def feed_or_retry (retry_seconds=2, &restclient_call_block)
    begin    
      json_data = restclient_call_block.call 

      # IP connection error, wrong url, etc.
      rescue SocketError => e
        STDERR.puts "#{Time.now}: socket error: #{e}. Possible net connection problems. Retry in #{retry_seconds} seconds."
        sleep retry_seconds
        retry

      # restclient exceptions
      rescue => e

      # 
      # HTTP status code manager
      #
      if 401 == e.response.code
        # Client authentication failed due to unknown client, no client authentication included, 
        # or unsupported authentication method
        # After your bearer token has expired, each request done with that stale token will return an HTTP code 401
        STDERR.puts "#{Time.now}:  restclient error. http status code: #{e.response.code}: #{e.response.body}. Invalid or expired token. Retry in #{retry_seconds} seconds."

        # opinabile mettere la sleep qui, ma meglio per evitare loop stretto
        sleep retry_seconds

        # richiede il token daccapo. da rivedere.
        @access_token = oauth_token
        retry

      elsif 404 == e.response.code
        STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Exit."
        exit

      # Invalid or blank request body given (selll services endpoints)
      elsif 422 == e.response.code
        STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Exit."
        exit

      elsif [500, 520].include? e.response.code
        STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Retry in #{retry_seconds} seconds."
        sleep retry_seconds
        retry

      else
        STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Exit."
        exit
      end
    end

    # HTTP status 200
    json_data
  end


  #
  # ritorna array con tutti gli items (di tutte le pagine) di uno shop
  # il metodo è iteratore su un blocco che deve essere passato, contenente chiamata ad endpoint
  # esempio di chiamata:
  # all_pages { |page, per_page| eal.shops_items(shop_id, {:page => page, :per_page => per_page}) } # , :order => "title_asc" 
  #
  def all_pages (debug=false, per_page=16, &endpoint_call_block)
    page = 1
    data = []

      print 'collecting items from pages ' if debug

    loop do
      print "." if debug # puts "#{__method__}: getting page #{page}..." 

      # esegue il blocco passato a cui sono passati due parametri: page, per_page.  
      json = endpoint_call_block.call page, per_page

      # %x{echo #{json} >> all_pages.log}

      # elabora i dati tornati dalla yield
      data_single_page = MultiJson.load json # JSON.parse

      # debug
      # data_single_page.each_with_index { |item, index| 
      #  puts "#{index+1}: title: #{item["title"]}, id: #{item["id"]}, shop: #{item["shop"]["id"]}" }

      data.concat data_single_page 

      break if (data_single_page.size < per_page) || data_single_page.empty?
      page += 1
    end

    print "\n" if debug 
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

  def api_url (api_endpoint) 
    "#{@domain}#{@api_version}#{api_endpoint}"
  end  

  def headers (params={})
    return {:authorization => "Bearer #{@access_token}", :params => params }
  end  


  #------------ 
  # OAUTH TOKEN
  #------------
  def oauth_token
    json_data = feed_or_retry { RestClient.post api_url('/oauth/token'), {
      grant_type: @grant_type,
      client_id: @client_id,
      client_secret: @client_secret,
      username: @username,
      password: @password } }

    puts_response_header(__method__, json_data) if @verbose_access_token

    data = MultiJson.load (json_data) # JSON.parse
    access_token = data["access_token"]
    #STDOUT.puts data
    #puts_access_token(access_token) if @verbose
    access_token
  end

  #-------------- 
  # BUY ENDPOINTS
  #--------------

  #
  # ITEMS
  #
  def items_discounted(params={})
    url = api_url '/items/discounted'
    feed_or_retry do 
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end  
  end

  def items_featured(params={})
    url = api_url '/items/featured'
    feed_or_retry do 
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end     
  end

  def items_hand_picked(params={})
    url = api_url '/items/hand_picked'
    feed_or_retry do
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end   
  end

  def items_list (item_id, params={})
    url = api_url '/items/list'
    h = headers({:id => item_id, :currency => @currency, :locale => @locale}.merge(params))
    feed_or_retry { RestClient.get url, h }
  end

  def items_most_liked(params={})
    url = api_url '/items/most_liked'
    feed_or_retry do
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end  
  end

  def items_search (keyword, params={})
    url = api_url '/items/search'
    h = headers({:q => keyword, :currency => @currency, :locale => @locale}.merge(params))
    feed_or_retry { RestClient.get url, h }
  end

  #
  # CATEGORIES
  #
  def categories_index(params={})
    url = api_url '/categories'
    feed_or_retry do
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end  
  end

  def categories_items (category_id, params={})
    url = api_url "/categories/#{category_id}/items" 
    feed_or_retry do
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end    
  end


  #
  # COLLECTIONS
  #
  def collections_index(params={})
    url = api_url '/collections'
    feed_or_retry do
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end  
  end

  def collections_items (collection_id, params={})
    url = api_url "/collections/#{collection_id}/items"
    feed_or_retry do
      RestClient.get url, headers({:currency => @currency, :locale => @locale}.merge(params))
    end  
  end

  #
  # COUNTRIES
  #
  def countries(params={})
    url = api_url '/countries'
    feed_or_retry do
      RestClient.get url, headers({:locale => @locale}.merge(params))
    end  
  end


  #
  # provinces
  #
  def provinces_show (province_id, params={})
    url = api_url "/provinces/#{province_id}"    
    feed_or_retry { RestClient.get url, headers(params) }
  end

  #
  # SHOPS
  #
  def shops_index (params={})
    url = api_url '/shops'
    feed_or_retry { RestClient.get url, headers(params) }
  end


  def shops_items (shop_id, params={})
    url = api_url "/shops/#{shop_id}/items"
    
    puts_url(url) if @verbose

    data = feed_or_retry { RestClient.get url, headers(params) }

    puts_response_header(__method__, data) if @verbose  
    data
  end


  def shops_item (shop_id, item_id, params={})
    url = api_url "/shops/#{shop_id}/items/#{item_id}"
    feed_or_retry { RestClient.get url, headers(params) }
  end

  def shops_show (shop_id, params={})
    url = api_url "/shops/#{shop_id}"
    feed_or_retry { RestClient.get url, headers(params) }
  end

  #
  # TAGS
  #
  def tags_index (params={})
    url = api_url "/tags"
    feed_or_retry { RestClient.get url, headers(params) }
  end

  def tags_items (tag_id, params={})
    url = api_url "/tags/#{tag_id}/items"
    feed_or_retry { RestClient.get url, headers(params) }
  end

  #--------------- 
  # SELL ENDPOINTS
  #---------------

  #
  # SELL_SHOP_ITEMS
  #
  def sell_shop_items (shop_id, params={})
    url = api_url '/sell/shop/items'
    h = headers({ :shop_id => shop_id }.merge(params))
    feed_or_retry { RestClient.get url, h }
  end

  def sell_shop_items_create (payload, params={})
    url = api_url '/sell/shop/items/new'
    feed_or_retry { RestClient.post url, payload, headers(params) }
  end

  def sell_shop_items_read (item_id, params={})
    url = api_url "/sell/shop/items/#{item_id}"
    feed_or_retry { RestClient.get url, headers(params) }
  end

  def sell_shop_items_update (item_id, payload, params={})
    url = api_url "/sell/shop/items/#{item_id}"
    feed_or_retry { RestClient.put url, payload, headers(params) }  
  end

  def sell_shop_items_delete (item_id, params={})
    url = api_url "/sell/shop/items/#{item_id}"
    feed_or_retry { RestClient.delete url, headers(params) }
  end

  end
end