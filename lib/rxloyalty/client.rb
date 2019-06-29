module Rxloyalty

  class Client

    def initialize(access_token = nil)
      @access_token = access_token || ENV['RXLOYALTY_ACCESS_TOKEN']
    end

    def perform_request(path, params)
      url = "http://testproc.cloud39.ru/BonusWebApi/api/#{path}"
      query = { LicenseGuid: @access_token }.merge(params).to_json
      response = HTTParty.post(url, headers: { 'Content-Type' => 'application/json' },
                                    body: query)
      JSON.parse(response.body)
    end

  end

end