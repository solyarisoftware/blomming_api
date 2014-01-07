# encoding: utf-8
require 'yaml'

module BlommingApi
  module Config

    def read_config_file(config_filename)

      # initialize instance variables, from config file 
      config = YAML.load_file config_filename

      # store filename as class instance variable 
      @config_filename = config_filename

      # initialize instance variables, from config files
      # validating mandatory properties

      @description  = config['description']
      
      # services: buy or sell
      @services  = config['services']
      if (@services.downcase =~ /buy|sell/).nil?
        raise "FATAL: config value for: services (#@services): invalid" 
      end

      @username  = config['username']
      if !(@services.downcase =~ /sell/).nil? && @username.nil?
        raise "FATAL: config value for: username: must be specified"
      end

      @password  = config['password']
      if !(@services.downcase =~ /sell/).nil? && @password.nil?
        raise "FATAL: config value for: password: must be specified"
      end

      @client_id  = config['client_id']
      raise "FATAL: config value for: client_id: must be specified" if @client_id.nil?

      @client_secret  = config['client_secret']
      raise "FATAL: value for: client_secret: must be specified" if @client_secret.nil?

      @domain  = config['domain']
      if (@domain.downcase =~ /https:\/\/|blomming/).nil?
        raise "FATAL: config value for: domain (#@services) invalid"
      end

      @api_version  = config['api_version']
      if (@api_version =~ /\/v\d+/).nil?
        raise "FATAL: config value for: api_version (#@api_version): invalid"
      end

      # default API endpoint parameters values 
      @currency = config['default_currency']
      @locale = config['default_locale']


      # assign default value: 2, 
      # if parameter is not set in config file
      @retry_seconds = config['retry_seconds']
      @retry_seconds = 2 if @retry_seconds.nil?

      # assign default value: false, 
      # if parameter is not set in config file
      @survive_on_fatal_error = config['survive_on_fatal_error']
      @survive_on_fatal_error = false if @survive_on_fatal_error.nil?

      # verbosity/debug
      @verbose = config['verbose']
      @verbose = false if @verbose.nil?
      @verbose_access_token = @verbose

      puts config_properties if @verbose
    end
    private :read_config_file

    def config_properties
      "\n           config file: #@config_file\n" +   
      "           description: #@description\n" +   
      "              services: #@services\n" + 
      "              username: #@username\n"  +
      "              password: #@password\n" + 
      "             client_id: #@client_id\n" + 
      "         client_secret: #@client_secret\n" + 
      "                domain: #@domain\n" +
      "      default_currency: #@currency\n" + 
      "        default_locale: #@locale\n" +
      "survive_on_fatal_error: #@survive_on_fatal_error\n"  +
      "         retry_seconds: #@retry_seconds\n\n"  
    end
    public :config_properties

  end
end
