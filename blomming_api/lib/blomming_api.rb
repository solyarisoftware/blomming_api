# encoding: utf-8
require 'yaml'
require 'multi_json'
require 'rest_client' # https://github.com/rest-client/rest-client

require 'blomming_api/version'
require 'blomming_api/help'

# modules
require 'blomming_api/config'
require 'blomming_api/private_helpers'
require 'blomming_api/oauth_endpoint'
require 'blomming_api/buy_endpoints'
require 'blomming_api/sell_endpoints'
require 'blomming_api/public_helpers'

module BlommingApi

  #
  # CLIENT ACCESS LOGIC
  #
  class Client
    
    private
      include Config
      include PrivateHelpers

    public
      include OauthEndpoint
      include BuyEndpoints
      include SellEndpoints
      include PublicHelpers

  	# instance variables, read-only
    attr_reader :description
    attr_reader :services, :grant_type 
    attr_reader :client_id, :client_secret, :username, :password
    attr_reader :domain, :api_version
    attr_reader :token_type, :expires_in, :refresh_token, :access_token
    
  	# instance variables, read/write
    attr_accessor :currency, :locale, :verbose

    # integer:
    # number of seconds between a call and the successive 
    # in case of a retry of an API call
    attr_reader :retry_seconds

    # boolean:
    # if false, in case of exceptions, process die with exit
    attr_reader :survive_on_fatal_error

    # new
    def initialize(config_filename)
      # read YAML configuration file
      read_config_file config_filename  

      # authenticate client when a new client is created
      authenticate :initialize
    end

  end
end