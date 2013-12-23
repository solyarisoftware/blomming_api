# encoding: utf-8
require 'yaml'

module BlommingApi
  module Config

    def read_config_file(config_filename)

      # initialize instance variables, from config file 
      config = YAML.load_file config_filename

      #
      # initialize instance variables, from config files
      # validating mandatory fields

      @description  = config['description']
      
      # services: buy or sell
      @services  = config['services']
      if (@services.downcase =~ /buy|sell/).nil?
        raise "FATAL: config value for: services (#@services): invalid" 
      end

      @username  = config['username']
      raise "FATAL: config value for: username: must be specified" if @username.nil?

      @password  = config['password']
      raise "FATAL: config value for: password: must be specified" if @password.nil?

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

      # other behaviours
      @verbose = config['verbose']
      @verbose_access_token = @verbose
      puts to_s(config_filename) if @verbose
    end
    private :read_config_file

    def show_config_file (config_file)
      "config file: #{config_file}\n\n" + 
      "\tdescription: #@description\n" +   
      "\tservices: #@services\n" + 
      "\tusername: #@username\n"  +
      "\tpassword: #@password\n" + 
      "\tclient_id: #@client_id\n" + 
      "\tclient_secret: #@client_secret\n" + 
      "\tdomain: #@domain\n" +
      "\tdefault_currency: #@currency\n" + 
      "\tdefault_locale: #@locale\n\n" 
    end
    public :show_config_file

  end
end
