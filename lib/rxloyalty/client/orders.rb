module Rxloyalty
  class Client

    module Orders

      def orders(card_code)
        post '/SiteController/DocHistory', CardCode: card_code
      end

      def register_order(card_code, card_item)
        # card_code - код бонусной карты.
        # card_item должен выглядить следующим образом: [{
        #       "PositionId": "String",
        #       "ProductCode": "String",
        #       "TotalPrice": 0, в рублях, можно с копейками
        #       "Quantity": 0,
        #       "Properties": {}
        #     }]
        params = { CardCode: card_code, CardRegisterDateTime: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
                   IsAdditionalCard: false, AllowFullBonusPay: false, RegisterDetailDtos: card_item }
        post '/api/processing/register', params
      end

      def cancel_order(card_code, card_item)
        # card_code - код бонусной карты.
        # card_item должен выглядить следующим образом: [{
        #       "PositionId": "String",
        #       "ProductCode": "String",
        #       "TotalPrice": 0, в рублях, можно с копейками
        #       "Quantity": 0,
        #       "Properties": {}
        #     }]
        # При удалении должен вернуть true
        params = { CardCode: card_code, CardRegisterDateTime: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
                   IsAdditionalCard: false, AllowFullBonusPay: false, RegisterDetailDtos: card_item }
        post '/api/processing/cancel', params
      end

      def sale_order(order)

        new = camelcase_sale_order(order)
        params = { DocumentDateTime: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
                   DocumentDiscountDtos: new.delete(:discount), DocumentDetailDtos: new.delete(:order_items) }.merge(new)
        post '/api/processing/sale', params
      end

      private

      def camelcase_sale_order(order)
        new = {}
        order.each do |key, value|
          if value.class == Array
            new_val = []
            value.map do |arr|
              new_arr = camelcase_sale_order(arr)
              new_val << new_arr
            end
            new[key] = new_val
          else
            new_key = key.to_s.tr('_', ' ').split.map { |i| i.capitalize }.join.to_sym
            new[new_key] = value
          end
        end
        new
      end

    end

  end
end