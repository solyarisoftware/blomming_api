#!/bin/env ruby
# encoding: utf-8
require_relative '_orders_notifier'

# connect to Blomming API server
blomming = initialize_all

# process goes in background if configured to do
# Daemons.daemonize if go_background?
#Process.daemon if go_background?

# every n seconds fetch new orders from Blomming API sever, 
# and notify via SMS to Seller!
schedule_every @poll_seconds do
  new_orders_from blomming do |client, order|

    # notify with a SMS each new order!
    notify_sms client, order

    # 
    # change order status to "to_be_shipped" now ?
    # it's business logic decision:
    # right now (when new order is notified)
    # or it's better to defer status update when
    # order will be really processed ?
    #   
    # set_order_to_be_shipped(client, order) if success
    #
  end
end
