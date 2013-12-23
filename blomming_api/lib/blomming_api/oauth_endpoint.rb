# encoding: utf-8
require 'multi_json'
require 'rest_client'

module BlommingApi
  module OauthEndpoint
    #
    # authentication request
    # 
    # => to get initial OAuth access token:
    # 
    #        authenticate :initialize
    #
    # => to get refresh token in case of OAuth access token expired  
    # 
    #        authenticate :refresh
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
          raise"FATAL: config value for: services (#@services): invalid"    
        end
      
      elsif type == :refresh
      	@grant_type = "refresh_token"
        auth_params.merge! \
          grant_type: @grant_type, refresh_token: @refresh_token
      
      else
          raise "FATAL: incorrect authentication type (#{type})"    
      end     

      data = load_or_retry do 
        RestClient.post url, auth_params
      end  

      #puts_response_header(__method__, data) if @verbose_access_token
      #puts_access_token(access_token) if @verbose

      # assign all token info to instance variables
      @token_type = data["token_type"]
      @expires_in = data["expires_in"]
      @refresh_token = data["refresh_token"]
      @access_token = data["access_token"]
    end
    private :authenticate


    def show_authentication (config_file)
      "\tservices: #{@services}\n" +
      "\tgrant_type: #{@grant_type}\n" +       
      "\tusername: #{@username}\n" + 
      "\tpassword: #{@password}\n" + 
      "\tclient_id: #{@client_id}\n" + 
      "\tclient_secret: #{@client_secret}\n\n" +

      "\ttoken_type: #{@token_type}\n" +
      "\texpires_in: #{@expires_in}\n" +
      "\trefresh_token: #{@refresh_token}\n" +
      "\taccess_token: #{@access_token}\n\n"
    end
    public :show_authentication

  end
end
