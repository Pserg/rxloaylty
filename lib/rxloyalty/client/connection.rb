module Rxloyalty
  class Client
    module Connection
      def post(path, options = {}, convert = true)
        request :post, path, options, convert
      end

      private

      def request(http_method, path, options, convert)
        @options.merge!(options)
        response = self.class.send(http_method, path, body: @options.to_json)
        if convert
          handle_rx_response(response) if convert
        else
          response.parsed_response
        end
      end
    end
  end
end
