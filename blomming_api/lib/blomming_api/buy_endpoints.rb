# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module BuyEndpoints
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

  end
end
