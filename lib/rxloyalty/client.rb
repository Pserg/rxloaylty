require 'rxloyalty/client/connection'
require 'rxloyalty/client/response'
require 'rxloyalty/client/cards'
require 'rxloyalty/client/orders'

module Rxloyalty
  class Client

    include HTTParty
    include Rxloyalty::Client::Connection
    include Rxloyalty::Client::Response
    include Rxloyalty::Client::Cards
    include Rxloyalty::Client::Orders


    base_uri ENV['RXLOYALTY_URI']
    format :json

    def initialize(access_token = nil)
      @options = { LicenseGuid: access_token || ENV['RXLOYALTY_ACCESS_TOKEN'] }
      self.class.default_options.merge!(headers: { 'Content-Type' => 'application/json' })
    end

  end
end