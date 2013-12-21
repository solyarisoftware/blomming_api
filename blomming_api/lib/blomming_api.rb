# encoding: utf-8
require 'yaml'
require 'multi_json'
require 'rest_client' # https://github.com/rest-client/rest-client

require "blomming_api/version"
require "./blomming_api/private_helpers"

module BlommingApi

=begin
  module PrivateHelpers
    #
    # build complete URL of any API request endpoint URI 
    #
    def api_url (api_endpoint_uri) 
	  "#{@domain}#{@api_version}#{api_endpoint_uri}"
    end  

  	#
    # return the hash to be used as HTTP header in all API requests,
    # embedding authentication token and all optional parameters
    # 
    def request_params(params={})
	  { authorization: "Bearer #{@access_token}", params: params }
    end
  end
=end

  #
  # CLIENT ACCESS LOGIC
  #
  class Client 
    include PrivateHelpers

    def initialize(config_filename)
      # read YAML configuration file
      read_config_file(config_filename)  

      # authenticate client when a new client is created
      authenticate :initialize
    end

    #
    # PRIVATE METHODS 
    #
    private

    def read_config_file(config_filename)

      # initialize instance variables, from config file 
      config = YAML.load_file(config_filename)

      # initialize instance variables, from config files     
      @client_app_description  = config['client_app_description']
      
      @services  = config['services'] # buy or sell
      @username  = config['username']
      @password  = config['password']
      @client_id  = config['client_id']
      @client_secret  = config['client_secret']
      @domain  = config['domain']
      @api_version  = config['api_version']

      # default values
      @currency = config['default_currency']
      @locale = config['default_locale']

      # other behaviours
      @verbose = config['verbose']
      @verbose_access_token = @verbose
      puts config_to_s(config_filename) if @verbose
    end

    #
    # private helper: manage RestClient exceptions. iterator.  
    #
    def load_or_retry (retry_seconds=2, &restclient_call_block)
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
          authenticate :refresh
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

      # HTTP status 200: return data (json to hash)
      MultiJson.load json_data
    end


    #
    # authentication request
    #
    def authenticate(type=:initialize)
      url = api_url('/oauth/token')
      services = @services.downcase.to_sym

      # client_id and client_secret are required for any kind of request 
      auth_params = { client_id: @client_id, client_secret: @client_secret }

      # authentication type must be :initalize or :refresh 
      if type == :initialize

        # authentication for services :buy or :sell 
        if services == :buy
          @grant_type = "client_credentials" 	
          auth_params.merge! grant_type: @grant_type

        elsif services == :sell
          @grant_type = "password"	
          auth_params.merge! \
            grant_type: @grant_type, username: @username, password: @password

        else
          raise "incorrect config parameter 'services' (= #{@services} )"    
        end
      
      elsif type == :refresh
      	@grant_type = "refresh_token"
        auth_params.merge! \
          grant_type: @grant_type, refresh_token: @refresh_token
      
      else
          raise "incorrect authentication 'type' (= :#{type} )"    
      end     

      data = load_or_retry do 
        RestClient.post url, auth_params
      end  

      #puts_response_header(__method__, data) if @verbose_access_token
      #puts_access_token(access_token) if @verbose

      @token_type = data["token_type"]
      @expires_in = data["expires_in"]
      @refresh_token = data["refresh_token"]
      @access_token = data["access_token"]
    end


    #
    # PUBLIC METHODS 
    #
    public

    def dump_pretty (json_data)
      # JSON.pretty_generate(JSON.parse(json_data))
      puts MultiJson.dump json_data, :pretty => true 
    end  

    def config_to_s (config_file)
      "config request_params(on #{config_file}:\n" + 
      "client_app_description: #{@client_app_description}\n" +   
      "services: #{@services}\n" + 
      "username: #{@username}\n" + 
      "password: #{@password}\n" + 
      "client_id: #{@client_id}\n" + 
      "client_secret: #{@client_secret}\n" + 
      "domain: #{@domain}\n" + 
      "default_currency: #{@currency}\n" + 
      "default_locale: #{@locale}\n\n" 
    end

    def authentication_to_s (config_file)
      "services: #{@services}\n" +
      "grant_type: #{@grant_type}\n" +       
      "username: #{@username}\n" + 
      "password: #{@password}\n" + 
      "client_id: #{@client_id}\n" + 
      "client_secret: #{@client_secret}\n\n" +

      "token_type: #{@token_type}\n" +
      "expires_in: #{@expires_in}\n" +
      "refresh_token: #{@refresh_token}\n" +
      "access_token: #{@access_token}\n\n"
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

    #-------------- 
    # BUY ENDPOINTS
    #--------------

    #
    # ITEMS
    #
    def items_discounted(params={})
      url = api_url '/items/discounted'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do 
        RestClient.get url, req
      end  
    end

    def items_featured(params={})
      url = api_url '/items/featured'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do 
        RestClient.get url, req
      end     
    end

    def items_hand_picked(params={})
      url = api_url '/items/hand_picked'
    req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end   
    end

    def items_list (item_id, params={})
      url = api_url '/items/list'
      req = request_params({id: item_id, currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end

    def items_most_liked(params={})
      url = api_url '/items/most_liked'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end

    def items_search (keyword, params={})
      url = api_url '/items/search'
      req = request_params({q: keyword, currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do 
        RestClient.get url, req
      end  
    end

    #
    # CATEGORIES
    #
    def categories_index(params={})
      url = api_url '/categories'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end

    def categories_items (category_id, params={})
      url = api_url "/categories/#{category_id}/items" 
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end    
    end


    #
    # COLLECTIONS
    #
    def collections_index(params={})
      url = api_url '/collections'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req 
      end  
    end

    def collections_items (collection_id, params={})
      url = api_url "/collections/#{collection_id}/items"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # COUNTRIES
    #
    def countries(params={})
      url = api_url '/countries'
      req = request_params({locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end


    #
    # provinces
    #
    def provinces_show (province_id, params={})
      url = api_url "/provinces/#{province_id}"    
      
      load_or_retry do 
        RestClient.get url, request_params(params)
      end  
    end

    #
    # SHOPS
    #
    def shops_index (params={})
      url = api_url '/shops'
      
      load_or_retry do
        RestClient.get url, request_params(params)
      end  
    end


    def shops_items (shop_id, params={})
      url = api_url "/shops/#{shop_id}/items"
      
      puts_url(url) if @verbose

      data = load_or_retry  do
        RestClient.get url, request_params(params)
      end

      puts_response_header(__method__, data) if @verbose  
      data
    end

    def shops_item (shop_id, item_id, params={})
      url = api_url "/shops/#{shop_id}/items/#{item_id}"
      
      load_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    def shops_show (shop_id, params={})
      url = api_url "/shops/#{shop_id}"
      
      load_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    #
    # TAGS
    #
    def tags_index (params={})
      url = api_url "/tags"
      
      load_or_retry do 
        RestClient.get url, request_params(params)
      end  
    end

    def tags_items (tag_id, params={})
      url = api_url "/tags/#{tag_id}/items"
      
      load_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    #--------------- 
    # SELL ENDPOINTS
    #---------------

    #
    # SELL_SHOP_ITEMS
    #
    def sell_shop_items (shop_id, params={})
      url = api_url '/sell/shop/items'
      req = request_params({ :shop_id => shop_id }.merge(params))

      load_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_items_create (payload, params={})
      url = api_url '/sell/shop/items/new'
      load = MultiJson.dump payload
      req = request_params(params)

      load_or_retry do
        RestClient.post url, load, req 
      end  
    end

    def sell_shop_items_read (item_id, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      req = request_params(params)

      load_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_items_update (item_id, payload, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      load = MultiJson.dump payload
      req = request_params(params)

      load_or_retry do
        RestClient.put url, load, req
      end    
    end

    def sell_shop_items_delete (item_id, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      req = request_params(params)

      load_or_retry do
        RestClient.delete url, req
      end  
    end

    #
    # PUBLIC HELPERS
    #

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
        raise "method require a block! usage: #{__method__} { |page, per_page| endpoint_method(..., {page: page, per_page: per_page}) }"
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

  end
end