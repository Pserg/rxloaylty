module Rxloyalty
  class Client

    module Orders

      # Return array of client orders by card number

      def orders(card_code)
        post '/SiteController/DocHistory', CardCode: card_code
      end


      # Метод для расчета скидок и маркетинговых программ
      #
      # card_code - код бонусной карты.
      # card_items должен выглядить следующим образом: [{
      #       "PositionId": "String",
      #       "ProductCode": "String",
      #       "TotalPrice": 0, в рублях, можно с копейками
      #       "Quantity": 0,
      #       "Properties": {}
      #     }]

      def register_order(card_code, card_items)
        params = { CardCode: card_code,
                   CardRegisterDateTime: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                   IsAdditionalCard: false, AllowFullBonusPay: false, RegisterDetailDtos: card_items }
        post '/api/processing/register', params
      end


      # Метод отмены заказа

      def cancel_order(order_id)
        params = { SiteOrderCode: order_id }
        post '/api/processing/CancelOrder', params
      end


      # Метод продажи (фиксации заказа)

      def sale_order(order)

        new = camel_case(order)
        params = { DocumentDateTime: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                   DocumentDiscountDtos: new.delete(:discount), DocumentDetailDtos: new.delete(:order_items) }.merge(new)
        post '/api/processing/sale', params
      end

      private

      def camel_case(order)
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
            new_key = key.to_s.tr('_', ' ').split.map(&:capitalize).join.to_sym
            new[new_key] = value
          end
        end
        new
      end

    end

  end
end