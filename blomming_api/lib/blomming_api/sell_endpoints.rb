# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module SellEndpoints

    #
    # PAYMENT_TYPES
    #
    def sell_payment_types_find (params={})
      url = api_url "/sell/payment_types​/user_list"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_payment_types_create (payload, params={})
      url = api_url "/sell/payment_types​/new"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

    def sell_payment_types_update (id, payload, params={})
      url = api_url "/sell/payment_types​/#{id}"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.put url, load, req 
      end  
    end

    def sell_payment_types_delete (id, params={})
      url = api_url "/sell/payment_types​/#{id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.delete url, req 
      end  
    end

    #
    # REGISTER
    #
    def sell_register (payload, params={})
      url = api_url "/sell/register"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

    #
    # SHIPPING_COUNTRIES
    #
    def sell_shipping_countries_all (params={})
      url = api_url "/sell/shipping_countries​​/all"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SHIPPING_PROFILES
    #
 
    def sell_shipping_profiles (params={})
      url = api_url "/sell/shipping_profiles"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end
    end

    def sell_shipping_profile_create (payload, params={})
      url = api_url "/sell/shipping_profiles"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

=begin
    def sell_shipping_profile_update (payload, params={})
      url = api_url "/sell/shipping_profiles"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.put url, load, req 
      end  
    end
=end

    def sell_shipping_profile_update (payload, params={})
      url = api_url "/sell/shipping_profiles/#{id}"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.put url, load, req 
      end  
    end

    def sell_shipping_profile_delete (id, params={})
      url = api_url "/sell/payment_types​/#{id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.delete url, req 
      end  
    end

    def sell_shipping_profile_find (id, params={})
      url = api_url "/sell/payment_types​/#{id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req 
      end  
    end

    def sell_shipping_profile_item_create (payload, item_id, params={})
      url = api_url "/sell/shipping_profiles/items​/#{item_id}"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end


    #
    # SHIPPING_REGIONS
    #
    def sell_shipping_regions (params={})
      url = api_url "/sell/shipping_regions​/all"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SHOP_DASHBOARD
    #
    def sell_shop_dashboard (params={})
      url = api_url "/sell/shop/dashboard"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SHOP_ITEMS
    #
    def sell_shop_items (params={})
      url = api_url '/sell/shop/items'
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_item_create (payload, params={})
      url = api_url '/sell/shop/items/new'
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.post url, load, req 
      end  
    end

    def sell_shop_item_find (item_id, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_item_update (item_id, payload, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      load = MultiJson.dump payload
      req = request_params(params)

      feed_or_retry do
        RestClient.put url, load, req
      end    
    end

    def sell_shop_item_delete (item_id, params={})
      url = api_url "/sell/shop/items/#{item_id}"
      req = request_params(params)

      feed_or_retry do
        RestClient.delete url, req
      end  
    end

    def sell_shop_item_tags_add(*tags, item_id, params)
      url = api_url "/sell/shop/items/#{item_id}/add_tags"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      # with a hash sends parameters as a urlencoded form body
      load = {:tags => tags.join(','), :multipart => true}

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end

    def sell_shop_item_tags_remove(*tags, item_id, params)
      url = api_url "/sell/shop/items/#{item_id}/remove_tag"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      # with a hash sends parameters as a urlencoded form body
      load = {:tags => tags.join(','), :multipart => true}

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end    



    #
    # SHOP_ORDERS
    #
    def sell_shop_orders_states (params={})
      url = api_url "/sell/shop/orders/states"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_orders (order_status, params={})
      url = api_url "/sell/shop/orders"
      req = request_params({ order_status: order_status, currency: @currency, locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_orders_find (order_number, params={})
      url = api_url "/sell/shop/orders/#{order_number}"
      req = request_params(params)

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    def sell_shop_orders_change_state (order_number, state, params={})
      url = api_url "/sell/shop/orders/#{order_number}/change_state"
      req = request_params({state: state}.merge(params))

      feed_or_retry do
        # POST with a hash sends parameters as a urlencoded form body
        RestClient.post url, req
      end  
    end


    def sell_shop_orders_request_cancellation (order_number, reason_string, params={})
      url = api_url "/sell/shop/orders/#{order_number}/request_cancellation"
      req = request_params(params)
      load = MultiJson.dump reason: reason_string

      feed_or_retry do
        # POST with raw payloads
        RestClient.post url, load, req
      end  
    end

    #
    # SHOP_SHIPPING_PROFILES
    #
    def sell_shop_shipping_profiles (params={})
      url = api_url "/sell/shop/shipping_profiles"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # SHOP_USER_DETAILS
    #
    def sell_shop_user_details (params={})
      url = api_url "/sell/shop/user_details"
      req = request_params({locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

  end
end