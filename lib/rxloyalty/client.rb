require 'rxloyalty/client/connection'
require 'rxloyalty/client/response'
require 'rxloyalty/client/cards'
require 'rxloyalty/client/orders'
require 'rxloyalty/client/accounts'

module Rxloyalty
  class Client

    include HTTParty
    include Rxloyalty::Client::Connection
    include Rxloyalty::Client::Response
    include Rxloyalty::Client::Cards
    include Rxloyalty::Client::Orders
    include Rxloyalty::Client::Accounts


    format :json

    def initialize(access_token = nil)
      @options = { LicenseGuid: access_token || ENV['RXLOYALTY_ACCESS_TOKEN'] }
      self.class.default_options.merge!(headers: { 'Content-Type' => 'application/json' })
    end

    private

    def camel_case(params)
      new = {}
      params.each do |key, value|
        if value.class == Array
          new_val = []
          value.map do |arr|
            new_arr = camel_case(arr)
            new_val << new_arr
          end
          new[key] = new_val
        else
          new_key = key.to_s.tr('_', ' ').split.map(&:capitalize).join.to_sym
          new[new_key] = value
        end
      end
      new
    end


  end
end