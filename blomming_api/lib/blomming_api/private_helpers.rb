# encoding: utf-8
require 'multi_json'

module BlommingApi
  module PrivateHelpers
    #
    # build complete URL of any API request endpoint URI 
    #
    def api_url (api_endpoint_uri) 
	  "#{@domain}#{@api_version}#{api_endpoint_uri}"
    end  

  	#
    # return the hash to be used as HTTP header in all API requests,
    # embedding authentication token and all optional parameters
    # 
    def request_params(params={})
	  { authorization: "Bearer #{@access_token}", params: params }
    end

    #
    # private helper: manage RestClient exceptions. iterator.  
    #
    def load_or_retry (retry_seconds=2, &restclient_call_block)
      begin    
        json_data = restclient_call_block.call 

        # IP connection error, wrong url, etc.
        rescue SocketError => e
          STDERR.puts "#{Time.now}: socket error: #{e}. Possible net connection problems. Retry in #{retry_seconds} seconds."
          sleep retry_seconds
          retry

        # restclient exceptions
        rescue => e

        # 
        # HTTP status code manager
        #
        if 401 == e.response.code
          # Client authentication failed due to unknown client, no client authentication included, 
          # or unsupported authentication method
          # After your bearer token has expired, each request done with that stale token will return an HTTP code 401
          STDERR.puts "#{Time.now}:  restclient error. http status code: #{e.response.code}: #{e.response.body}. Invalid or expired token. Retry in #{retry_seconds} seconds."

          # opinabile mettere la sleep qui, ma meglio per evitare loop stretto
          sleep retry_seconds

          # richiede il token daccapo. da rivedere.
          authenticate :refresh
          retry

        elsif 404 == e.response.code
          STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Exit."
          exit

        # Invalid or blank request body given (selll services endpoints)
        elsif 422 == e.response.code
          STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Exit."
          exit

        elsif [500, 520].include? e.response.code
          STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Retry in #{retry_seconds} seconds."
          sleep retry_seconds
          retry

        else
          STDERR.puts "#{Time.now}: restclient error. http status code: #{e.response.code}: #{e.response.body}. Exit."
          exit
        end
      end

      # HTTP status 200: return data (json to hash)
      MultiJson.load json_data
    end

  end
end
