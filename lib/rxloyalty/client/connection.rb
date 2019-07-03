module Rxloyalty

  class Client

    module Connection

      def get(path, options = {})
        request :get, path, options
      end

      def post(path, options = {})
        request :post, path, options
      end

      def put(path, options = {})
        request :put, path, options
      end

      def delete(path, options = {})
        request :delete, path, options
      end

      private

      def request(http_method, path, options)
        @options.merge!(options)
        response = self.class.send(http_method, path, body: @options.to_json)
        response.parsed_response
      end

    end

  end
end
