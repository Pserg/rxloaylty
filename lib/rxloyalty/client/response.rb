module Rxloyalty

  class Client

    module Response

      def handle_rx_response(response)
        convert(response).merge(code: response.code, success: response.success?)
      end

      private

      def convert(response)
        symbolize_recursive(response)
      end

      def symbolize_recursive(hash)
        {}.tap do |h|
          hash.each { |key, value| h[key.snakecase.to_sym] = map_value(value) }
        end
      end

      def map_value(thing)
        case thing
        when Hash
          symbolize_recursive(thing)
        when Array
          thing.map { |v| map_value(v) }
        else
          thing
        end
      end

    end

  end
end
