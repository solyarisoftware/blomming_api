#!/bin/env ruby
# encoding: utf-8
require 'set'
require 'logger'  

# https://github.com/welaika/skuby
require 'skuby' 

require 'blomming_api'

@poll_seconds = 30

# false => disable SMS TX (to debug)
@send_sms = false

# true => demonize process
@go_background = false

# false => log to STDOUT; true => log to file
@log_to_file = false


#
# new_orders_from
#
# status = '' mean getting all orders in OPEN state!
# If this param is not given, only Order in an open state 
# (those orders whose state is equal to one of the following: 
# to_pay_not_shipped, to_pay_shipped, to_ship_paid, to_ship_not_paid) will be returned.
# https://blomming-api-staging.herokuapp.com/docs/v1/sell/shop/orders-GET.html
#
def new_orders_from (client, &block)
  
  orders = client.all_pages (:quiet) { |page, per_page| 
    client.sell_shop_orders '', {page: page, per_page: per_page}
  }

  if orders.size == 0
    @logger.info "No New orders found"
  else
    # NOTIFY EACH ORDER!
    orders.each { |order| block.call client, order }
  end

end


#
# notify order to Seller sending a SMS with order details. 
# return status of SMS TX (success?)
#
def notify_sms (c, order)

  # notify only if not already done! 
  unless already_notified order
    #dump_order = MultiJson.dump order, :pretty => true
    
    # log order data
    @logger.info "NEW ORDER: #{order["order_id"]} (num products: #{order["num_products"]}, \
price: #{order["price"]} #{order["currency_code"]}, current state: #{order["current_state"]})"    

    # format SMS text with order details 
    message = compose_sms_with_order_details c, order

    # send SMS through Skuby API (interfacing Skebby Gateway)
    sms_sent = send_sms(message,  @seller_cell_number, @logger) if @send_sms

    @logger.info "SMS SENT:\n#{message}" # if sms_sent #logger.debug
    
    # if SMS TX is disable, mark as notified anyway (debug)
    set_notified! order if (sms_sent || !@send_sms)

    # return status (success/error)
    sms_sent
  else
    true
  end
end


#
# verify if order is already notified 
# 
def already_notified(order) 
  @notified_orders_set.include? order["order_id"]
end


#
# set order as notified 
#
def set_notified!(order)
  @notified_orders_set.add order["order_id"]
end


#
# return a text containing the order details
# in a format suitable for a SMS message.
# 
# Example of formatted message:
#
# NEW ORDER 3bba016d12ed0a99
# 1 PIZZA QUATTRO STAGIONI
# 1 PIZZA MARGHERITA
# TOT 2.0EUR
# Giorgio Robino
# via Pietro Bozzano 2/10, Genova
# 3900000000
#
def compose_sms_with_order_details (c, order_index)

  order_id = order_index["order_id"]

  # get order detail details with specific API endpoint 
  order = c.sell_shop_orders_find order_id

  # New order with order ID as reference
  text = "NEW ORDER #{order_id}\n"

  products = order["products_details"]
  first_name = order["billing_address"]["first_name"]
  last_name = order["billing_address"]["last_name"]
  street = order["billing_address"]["street"]
  city = order["billing_address"]["city"]
  phone = order["contact_details"]["phone"]

  # product list
  products.each do |product|
    text << "#{product["quantity"]} #{product["name"]}\n"
  end 

  # Total price
  text << "TOT #{order["price"]}#{order["currency_code"]}\n"

  # Buyer address 
  text << "#{first_name} #{last_name}\n"
  text << "#{street}, #{city}\n"

  # Buyer phone contact
  text << "#{phone}\n"
end


def set_order_to_be_shipped (client, order, state)
  order_id = order["order_id"]
  state = "to_be_shipped"

  client.sell_shop_orders_change_state order_id, state

  # delete order id from set
  @notified_orders_set.delete order_id  
end


#
# connect to Blomming API server
#
def blomming_init (config_file)
  blomming = BlommingApi::Client.new config_file 

  #log.info blomming.config_properties

  # shop_id == username
  shop_id = blomming.username
  
  @logger.info "Successfully connected with Blomming API Server, for shop: #{shop_id}"
  
  blomming
end


#
# Initialize Skuby (SMS TX through Skebby enabler gem)
#
def skuby_init
  Skuby.setup do |config|
    config.method = 'send_sms_classic'
    config.username = @username
    config.password = @password
    config.sender_string = 'BLOMMING'
    #config.sender_number = 'xxxxxxxxxxxx'
    config.charset = 'UTF-8'
  end
end


#
# Send SMS via Skuby
# log response data
# return status
#
def send_sms (text, receiver, logger) 
  sms = Skuby::Gateway.send_sms text, receiver

  if sms.success? 
    response = { status: sms.status, 
                 text: text, 
                 receiver: receiver, 
                 remaining_sms: sms.remaining_sms
               }
    response.merge! sms_id: sms.sms_id if sms.sms_id?

    logger.debug "SMS SENT: #{response.to_s}"

  else
    response = { status: sms.status, 
                 error_code: sms.error_code, 
                 error_message: sms.error_message, 
                 text: text, 
                 receiver: receiver
               }
    response.merge! sms_id: sms.sms_id if sms.sms_id?

    logger.error "SMS SENT: #{response.to_s}"  
  end

  sms.success?
end


#
# schedule_every(n)
#
# From book: Ruby_cookbook, chapter 3.12. 
# in most cases, you don't want every_n_seconds 
# to take the main loop of your program.
#
def schedule_every(n, &block)

    while true do
      before = Time.now

      block.call
      
      elapsed = Time.now - before
      interval = n - elapsed
      
      @logger.debug "orders processing/delivery take #{elapsed} seconds."
      
      sleep(interval) if interval > 0
    end

end


def go_background?
  @go_background == true
end


def logger_init
  if go_background? || log_to_file?

    @log_file_name = "#{File.basename("#{$0}", ".rb")}.log" # 'orders_notifier.log'

    # Keep data for today and the past 7 days.  
    @logger = Logger.new(@log_file_name, 'weekly')  
  else
    @logger = Logger.new(STDOUT) 
  end  

  # configurazione log
  # http://www.ruby-doc.org/stdlib-2.0.0/libdoc/logger/rdoc/Logger.html
  # http://hawkins.io/2013/08/using-the-ruby-logger/
  # http://www.ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html
  @logger.datetime_format = '%d-%m-%Y %H:%M:%S'
  @logger.level = Logger::INFO
  @logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime.strftime(@logger.datetime_format)}: #{msg}\n" # #{progname} - #{severity} -   
  end

  @logger
end


def log_to_file?
  @log_to_file == true
end


# get necessary environment variables
# get Blomming YAML configuration filename
def args_env_vars
  puts "SMS Order Notifier for Blomming, release: 1 February 2014, by: giorgio.robino@gmail.com"
  puts "CTRL+C to stop"

  # get necessary environment variables
  @username = ENV['SMSNOTIFIER_SKEBBY_USERNAME']
  @password = ENV['SMSNOTIFIER_SKEBBY_PASSWORD'] 
  @seller_cell_number = ENV['SMSNOTIFIER_SELLER_PHONENUM']

  if @username.nil? || @password.nil? || @seller_cell_number.nil?
    puts "please set environment variables:"
    puts "export SMSNOTIFIER_SKEBBY_USERNAME=your_skebby_username"
    puts "export SMSNOTIFIER_SKEBBY_PASSWORD=your_skebby_password"
    puts "export SMSNOTIFIER_SELLER_PHONENUM=seller_cell_number as: <country_prefix><number> by example: 391234567890"
    exit 1
  end

  # get Blomming YAML configuration filename
  if ARGV[0].nil?
    puts "  usage: #{$0} <blomming_config_file.yml>" 
    puts "example: ruby #{$0} $CONFIG"
    exit 2
  end

  blomming_config_file =  ARGV[0]
end


# Load from disk orders already notified set. 
# initialize set of order id that have been already notified
# quick&dirty solution: Marshal.load @notified_orders_set
def notified_orders_init

  @notified_orders_filename = 'orders_notified.dat'

  if File.exists? @notified_orders_filename
    @notified_orders_set = File.open(@notified_orders_filename) { |file| Marshal.load(file) }
  else
    @notified_orders_set = Set.new
  end
end


# when process will be killed, save to disk orders already notified set.
def trap_shutdown
  trap('INT') do
    # Marshal.dump @notified_orders_set
    File.open(@notified_orders_filename,'w') { |file| Marshal.dump(@notified_orders_set, file) }

    puts "#{$0} has ended (crowd applauds)"
    exit 0

  end
end


def initialize_all
  # Load from disk orders already notified set. 
  notified_orders_init

  # when process will be killed, 
  # save to disk orders already notified set.
  trap_shutdown  

  # get command line arguments
  config_file = args_env_vars

  # initialize logger
  logger_init

  # initialize Skuby, to send SMS with Skebby
  skuby_init

  # connect to Blomming API server
  blomming = blomming_init config_file
end
