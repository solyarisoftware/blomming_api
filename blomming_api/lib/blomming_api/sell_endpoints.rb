# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module SellEndpoints

    #
    # PAYMENT_TYPES
    #
    # TODO

    #
    # REGISTER
    #
    # TODO

    #
    # SHIPPING_COUNTRIES
    #
    # TODO

    #
    # SHIPPING_PROFILES
    #
    # TODO

    #
    # SHIPPING_REGIONS
    #
    # TODO

    #
    # SHOP_DASHBOARD
    #
    # TODO

    #
    # SHOP_ITEMS
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
    # SHOP_ORDERS
    #
    def sell_shop_orders_states (params={})
      url = api_url "/sell/shop/orders/states"
      req = request_params(params)

      load_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_orders (shop_id, order_status, params={})
      url = api_url "/sell/shop/orders"
      req = request_params({ shop_id: shop_id, order_status: order_status, currency: @currency, locale: @locale}.merge(params))

      load_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_orders_order_number (order_number, params={})
      url = api_url "/sell/shop/orders/#{order_number}"
      req = request_params(params)

      load_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_orders_order_number_change_state (state, params={})
      url = api_url "/sell/shop/orders/#{order_number}/change_state"
      req = request_params({state: state}.merge(params))

      load_or_retry do
        # POST with a hash sends parameters as a urlencoded form body
        RestClient.post url, req
      end  
    end


    def sell_shop_orders_order_number_request_cancellation (reason_string, params={})
      url = api_url "/sell/shop/orders/#{order_number}/request_cancellation"
      req = request_params(params)
      load = MultiJson.dump reason: reason_string

      load_or_retry do
        # POST with raw payloads
        RestClient.post url, load, req
      end  
    end

    #
    # SHOP_SHIPPING_PROFILES
    #
    # TODO

    #
    # SHOP_USER_DETAILS
    #
    def sell_shop_user_details (params={})
      url = api_url "/sell/shop/user_details"
      req = request_params({locale: @locale}.merge(params))

      load_or_retry do
        RestClient.get url, req
      end  
    end

  end
end