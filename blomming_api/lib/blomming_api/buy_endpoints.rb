# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module BuyEndpoints
    #
    # CARTS
    #
    def carts_add(skus, params={})
      url = api_url '/carts/add'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      load = MultiJson.dump skus

      load_or_retry do
        # POST with raw JSON payloads ?
        RestClient.put url, load, req
      end  
    end

    def carts_checkout(order, params={})
      url = api_url '/carts/checkout'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      load = MultiJson.dump order
      
      load_or_retry do
        # POST with raw JSON payloads ?
        RestClient.post url, load, req
      end  
    end

    def carts_clear(params={})
      url = api_url '/carts/clear'
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      load_or_retry do
        # PUT with a hash sends parameters as a urlencoded form body ?
        RestClient.put url, req
      end  
    end

    def carts_create(sku_id, params={})
      url = api_url '/carts/create'
      req = request_params({sku_id: sku_id, currency: @currency}.merge(params))
 
      # debug
      puts req
      
      load_or_retry do
        # with a hash sends parameters as a urlencoded form body
        RestClient.post url, req #load,
      end  
    end
=begin
    def carts_create(sku_id, params={})
      url = api_url '/carts/create'
      req = request_params(params)
 
      load = MultiJson.dump({sku_id: sku_id, currency: @currency})
      
      # debug
      puts load
      
      load_or_retry do
        RestClient.post url, load, req
      end  
    end
=end


    def carts_place_paypal_order(paypal_order, params={})
      url = api_url '/carts/place_paypal_order'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      load = MultiJson.dump paypal_order
      
      load_or_retry do
        RestClient.post url, load, req
      end  
    end

    def carts_remove(skus, params={})
      url = api_url '/carts/remove'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      load = MultiJson.dump skus

      load_or_retry do
        RestClient.put url, load, req
      end  
    end

    def carts_shipping_countries(params={})
      url = api_url '/carts/shipping_countries'
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      load_or_retry do
        RestClient.get url, req
      end  
    end

    def carts_show(cart_id, params={})
      url = api_url '/carts/#{cart_id}/show'
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      load_or_retry do
        RestClient.get url, req
      end  
    end

    def carts_validate(cart_id, params={})
      url = api_url '/carts/#{cart_id}/validate'
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      load_or_retry do
        RestClient.get url, req
      end  
    end


    #
    # CATEGORIES
    #
    def categories(params={})
      url = api_url '/categories'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end

    def category_items (category_id, params={})
      url = api_url "/categories/#{category_id}/items" 
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end    
    end

    #
    # COLLECTIONS
    #
    def collections(params={})
      url = api_url '/collections'
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req 
      end  
    end

    def collection_items (collection_id, params={})
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
    # CURRENCIES
    #
    def currencies(params={})
      url = api_url '/currencies'
      req = request_params({locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end
    
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
    # MACROCATEGORIES
    #
    def macrocategories(params={})
      url = api_url '/macrocategories'
      req = request_params({locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end  
    end

    def macrocategory_categories (macrocategory_id​, params={})
      url = api_url "/macrocategories​/:macrocategory_id​/categories" 
      req = request_params({locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end    
    end

    def macrocategory_items (macrocategory_id​, params={})
      url = api_url "/macrocategories​/:macrocategory_id​/items" 
      req = request_params({locale: @locale}.merge(params))
      
      load_or_retry do
        RestClient.get url, req
      end    
    end


    #
    # PASSWORD_RESETS
    #
    def password_resets (email_of_user, params={})
      url = api_url "/password_resets"    
      
      load_or_retry do
        # payload JSON ?
        RestClient.post url, {email_of_user: email_of_user}.merge(params)
      end  
    end


    #
    # PROVINCES
    #
    def provinces (province_country_code, params={})
      url = api_url "/provinces/#{province_country_code}"    
      
      load_or_retry do 
        RestClient.get url, request_params(params)
      end  
    end

    #
    # SHOPS
    #
    def shops (params={})
      url = api_url '/shops'
      
      load_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    def shop_items (shop_id, params={})
      url = api_url "/shops/#{shop_id}/items"
      
      data = load_or_retry  do
        RestClient.get url, request_params(params)
      end

      #puts_response_header(__method__, data) if @verbose  
      data
    end

    def shop_item (shop_id, item_id, params={})
      url = api_url "/shops/#{shop_id}/items/#{item_id}"
      
      load_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    def shops_find (shop_id, params={})
      url = api_url "/shops/#{shop_id}"
      
      load_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    #
    # TAGS
    #
    def tags (params={})
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
