# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module BuyEndpoints
    #
    # BUY
    # CARTS
    #

    #
    # Create a new Cart on the server, as present in the home page of the web site.
    # It also redirects to the Cart URL.
    #
    # :sku_id => SKU identifier (numeric) 
    #
    def carts_create(sku_id, params={})
      url = api_url "/carts"
      req = request_params({currency: @currency}.merge(params)) 
        
      # with a hash sends parameters as a urlencoded form body
      load = {sku_id: sku_id, multipart: true}

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end

    #
    # Returns the Cart with the given ID, as returned from the create cart API.
    #
    # :cart_id => Cart Identifier (numeric) 
    #
    def carts_find(cart_id, params={})
      url = api_url "/carts/#{cart_id}"
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Add multiple SKUs to the Cart.
    #
    # params:
    #   :*skus => SKU list 
    #   :cart_id => Cart Identifier (numeric) 
    # 
    # example:
    #   data = blomming.carts_add(608394, 608390, cart_id, {})
    #    
    def carts_add(*skus, cart_id, params)
      url = api_url "/carts/#{cart_id}/add"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      # with a hash sends parameters as a urlencoded form body
      load = {skus: skus.join(','), multipart: true}

      feed_or_retry do
        RestClient.put url, load, req
      end  
    end

    #
    # Remove multiple SKUs from the Cart. 
    #
    # params:
    #   :*skus => SKU list 
    #   :cart_id => Cart Identifier (numeric) 
    # 
    # example:
    #   data = blomming.carts_remove(608394, 608390, cart_id, {})
    #    
    #
    def carts_remove(*skus, cart_id, params)
      url = api_url "/carts/#{cart_id}/remove"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      # with a hash sends parameters as a urlencoded form body
      load = {skus: skus.join(','), multipart: true}

      feed_or_retry do
        RestClient.put url, load, req
      end  
    end

    #
    # Remove all SKUs from the Cart. 
    #
    # params:
    #   :cart_id => Cart Identifier (numeric) 
    #   
    def carts_clear(cart_id, params={})
      url = api_url "/carts/#{cart_id}/clear"
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      feed_or_retry do
        # PUT with a hash sends parameters as a urlencoded form body ?
        RestClient.put url, req
      end  
    end

    #
    # Returns countries to which this Cart can be shipped to.
    #
    # params:
    #   :cart_id => Cart Identifier (numeric) 
    #   
    def carts_shipping_countries(cart_id, params={})
      url = api_url "/carts/#{cart_id}/shipping_countries"
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Returns the Cart with the given ID, as returned from the create cart API. 
    # 
    # example:
    #
    # order = {
    #  ship_to_first_name: "Andrea",
    #  ship_to_last_name: "Salicetti",
    #  ship_to_address: "via%20Teodosio%2065",
    #  ship_to_postal_code: 20100,
    #  ship_to_city: "Milano",
    #  ship_to_province: "MI",
    #  ship_to_country: "Italy",
    #  bill_is_ship: "false",
    #  bill_to_first_name: "Nicola%20Junior",
    #  bill_to_last_name: "Vitto",
    #  bill_to_address: "via%20Teodosio%2065",
    #  bill_to_postal_code: "20100",
    #  bill_to_city: "Milano",
    #  bill_to_province: "MI",
    #  bill_to_country: "Italy",
    #  bill_to_company: "Blomming%20SpA",
    #  bill_to_vat_number: "IT07199240966",
    #  phone_number3: ""
    # }
    #    
    #   data = blomming.carts_validate_order(608394, order, "MOO", {})
    #
    def carts_validate_order(cart_id, order, payment_type, params={})
      url = api_url "/carts/#{cart_id}/validate/#{payment_type}"
      req = request_params({order: order, currency: @currency, locale: @locale}.merge(params))

      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Checkout of the Cart.
    # 
    # example:
    #
    # order = {
    #  ship_to_first_name: "Andrea",
    #  ship_to_last_name: "Salicetti",
    #  ship_to_address: "via%20Teodosio%2065",
    #  ship_to_postal_code: 20100,
    #  ship_to_city: "Milano",
    #  ship_to_province: "MI",
    #  ship_to_country: "Italy",
    #  bill_is_ship: "false",
    #  bill_to_first_name: "Nicola%20Junior",
    #  bill_to_last_name: "Vitto",
    #  bill_to_address: "via%20Teodosio%2065",
    #  bill_to_postal_code: "20100",
    #  bill_to_city: "Milano",
    #  bill_to_province: "MI",
    #  bill_to_country: "Italy",
    #  bill_to_company: "Blomming%20SpA",
    #  bill_to_vat_number: "IT07199240966",
    #  phone_number3: ""
    # }
    #    
    #   data = blomming.carts_checkout_order(608394, order, "MOO", {})
    #
    def carts_checkout_order(cart_id, order, payment_type, params={})
      url = api_url "/carts/#{cart_id}/checkout/#{payment_type}"
      req = request_params({currency: @currency, locale: @locale}.merge(params))

      # with a hash sends parameters as a urlencoded form body
      load = {order: order, multipart: true}
      
      feed_or_retry do
        RestClient.post url, load, req
      end  
    end

    #
    # Complete a PayPal transaction
    #
    def carts_place_paypal_order(cart_id, order_id, paypal_token, paypal_payer_id, params={})
      url = api_url "/carts/#{cart_id}/order/#{order_id}/place_paypal"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      # with a hash sends parameters as a urlencoded form body
      load = {token: paypal_token, PayerID: paypal_payer_id, multipart: true}

      feed_or_retry do
        RestClient.post url, load, req
      end  
    end


    #
    # BUY
    # CATEGORIES
    #

    #
    # Returns the categories
    #
    def categories(params={})
      url = api_url "/categories"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Returns all the Items (paged) belonging to a certain category.
    #
    def category_items (category_id, params={})
      url = api_url "/categories/#{category_id}/items" 
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end    
    end

    #
    # BUY 
    # COLLECTIONS
    #

    #
    # Returns the collections
    #
    def collections(params={})
      url = api_url "/collections"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req 
      end  
    end

    #
    # Returns the Items of a shop.
    #
    def collection_items (collection_id, params={})
      url = api_url "/collections/#{collection_id}/items"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # BUY
    # COUNTRIES
    #

    #
    # Get the full list of the possible Countries, localized.
    #
    def countries(params={})
      url = api_url "/countries"
      req = request_params({locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # BUY
    # CURRENCIES
    #

    #
    # Returns currencies accepted by Blomming
    #
    def currencies(params={})
      url = api_url "/currencies"
      req = request_params({locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end  
    end
    
    #
    # BUY
    # ITEMS
    #

    #
    # Returns the “discounted” Items, as present in the home page of the web site
    #
    def items_discounted(params={})
      url = api_url "/items/discounted"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do 
        RestClient.get url, req
      end  
    end

    #
    # Returns the “featured” Items, as present in the home page of the web site.
    #
    def items_featured(params={})
      url = api_url "/items/featured"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do 
        RestClient.get url, req
      end     
    end

    #
    # Returns the “hand picked” Items, as present in the home page of the web site.
    #
    def items_hand_picked(params={})
      url = api_url "/items/hand_picked"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end   
    end

    #
    # Returns the Items with the specified ids. 
    #
    def items_list (item_id, params={})
      url = api_url "/items/list"
      req = request_params({id: item_id, currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Returns the “most_liked” Items, as present in the home page of the web site.
    #
    def items_most_liked(params={})
      url = api_url "/items/most_liked"
      req = request_params({currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Search Blomming for items that respond to a query.
    #
    def items_search (keyword, params={})
      url = api_url "/items/search"
      req = request_params({q: keyword, currency: @currency, locale: @locale}.merge(params))
      
      feed_or_retry do 
        RestClient.get url, req
      end  
    end

    #
    # BUY
    # MACROCATEGORIES
    #

    #
    # Returns the Macrocategories
    #
    def macrocategories(params={})
      url = api_url "/macrocategories"
      req = request_params({locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end  
    end

    #
    # Returns the Categories included in the given Macrocategory.
    #
    def macrocategory_categories (macrocategory_id​, params={})
      url = api_url "/macrocategories​/#{macrocategory_id}​/categories" 
      req = request_params({locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end    
    end

    #
    # Returns the Items inside a Macrocategory.
    #
    def macrocategory_items (macrocategory_id​, params={})
      url = api_url "/macrocategories​/#{macrocategory_id}/items" 
      req = request_params({locale: @locale}.merge(params))
      
      feed_or_retry do
        RestClient.get url, req
      end    
    end


    #
    # BUY
    # PASSWORD_RESETS
    #

    #
    # Perform a password reset request to Blomming.
    # If it does succeed, an email is sent to the user 
    # with the link to renew his passowrd for Blomming.
    #
    def password_resets (email_of_user, params={})
      url = api_url "/password_resets"    
      
      feed_or_retry do
        # payload JSON ?
        RestClient.post url, {email_of_user: email_of_user}.merge(params)
      end  
    end


    #
    # BUY
    # PROVINCES
    #

    #
    # Retruns the provinces list for a given Country.
    #
    def provinces (province_country_code, params={})
      url = api_url "/provinces/#{province_country_code}"    
      
      feed_or_retry do 
        RestClient.get url, request_params(params)
      end  
    end

    #
    # BUY
    # SHOPS
    #

    #
    # Returns the Shops list
    #
    def shops (params={})
      url = api_url "/shops"
      
      feed_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    #
    # Returns the Items of a Shop. 
    # :shop_id is the Shop id (the User’s login owner of the Shop) 
    # as returned from the /shops endpoint.
    #
    def shop_items (shop_id, params={})
      url = api_url "/shops/#{shop_id}/items"
      
      data = feed_or_retry  do
        RestClient.get url, request_params(params)
      end

      #puts_response_header(__method__, data) if @verbose  
      data
    end

    #
    # Returns the details of an Item.
    #
    def shop_item (shop_id, item_id, params={})
      url = api_url "/shops/#{shop_id}/items/#{item_id}"
      
      feed_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    #
    # Get the details of a single Shop. 
    # :id is the Shop id (the User’s login owner of the Shop) 
    # as returned from the /shops endpoint.
    #
    def shops_find (shop_id, params={})
      url = api_url "/shops/#{shop_id}"
      
      feed_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

    #
    # BUY 
    # TAGS
    #

    #
    # Retrieve the tags.
    #
    def tags (params={})
      url = api_url "/tags"
      
      feed_or_retry do 
        RestClient.get url, request_params(params)
      end  
    end

    #
    # Returns the Items with a specific tag.
    #
    def tags_items (tag_id, params={})
      url = api_url "/tags/#{tag_id}/items"
      
      feed_or_retry do
        RestClient.get url, request_params(params)
      end  
    end

  end
end
