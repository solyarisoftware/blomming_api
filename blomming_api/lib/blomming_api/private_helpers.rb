# encoding: utf-8
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
  end
end

