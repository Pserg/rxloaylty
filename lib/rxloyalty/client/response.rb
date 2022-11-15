module Rxloyalty

  class Client

    module Response

      def handle_rx_response(response)
        convert(response.parsed_response)
          .merge(code: response.code, success: response.success?)
      end

      private

      def convert(response)
        return {} if response.blank?

        if response.is_a?(Hash)
          symbolize_recursive(response)
        else
          { data: response.map { |v| map_value(v) } }
        end
      end

      def symbolize_recursive(hash)
        {}.tap do |h|
          hash.each do |key, value|
            h[snake_case(key).to_sym] = map_value(value)
          end
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

      def snake_case(camel_cased_word)
        return camel_cased_word unless /[A-Z-]|::/.match?(camel_cased_word)

        camel_cased_word.gsub(/::/, '/')
                        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
                        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
                        .tr('-', '_')
                        .downcase
      end

    end

  end
end
