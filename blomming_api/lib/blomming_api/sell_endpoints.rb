# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module SellEndpoints

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

  end
end