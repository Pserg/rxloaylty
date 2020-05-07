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
      # "DocumentType": 14

      def cancel_order(order_id)
        params = { SiteOrderCode: order_id, DocumentType: 14 }
        post '/api/processing/CancelOrder', params
      end


      # Метод продажи (фиксации заказа)
      # {
      #     "DocumentType": 12,
      #     "DocumentCode": "some_code",
      #     "DocumentFiscalCode": "some",
      #     "DocumentParentCode": "",
      #     "DocumentDateTime": "2019-12-03 15:54:42",
      #     "SubjectCode": "",
      #     "CashboxCode": "14",
      #     "TotalSum": 74,
      #     "TotalSumDiscounted": 74,
      #     "DocumentDiscountDtos": [
      #     {
      #         "AccountId": 36891,
      #         "CardCode": "2018103099010",
      #         "SumBase": 74,
      #         "SumDiscounted": 74,
      #         "Discount": 0,
      #         "Percent": 0
      #     }
      # ],
      #     "DocumentDetailDtos": [
      #     {
      #         "ProductCode": "00001761",
      #         "Quantity": 2,
      #         "TotalPrice": 74,
      #         "TotalPriceDiscounted": 74,
      #         "MarketProgramId": 0
      #     }
      # ],SiteOrderCode: 123
      # }
      #

      def sale_order(order)
        post '/api/processing/sale', order_params(order, 12)
      end

      # Finalize order
      # { "DocumentType":1,"DocumentCode":"2079","DocumentFiscalCode":"2079","DocumentParentCode":"",
      # "DocumentDateTime":"2020-04-09 12:15:02","SubjectCode":"",
      # "CashboxCode":"1","TotalSum":1209,"TotalSumDiscounted":1209,
      # "DocumentDiscountDtos":[{"AccountId":35851,"CardCode":"2018100000001","SumBase":1209,"SumDiscounted":1209,
      # "Discount":0,"Percent":0}],"DocumentDetailDtos":[{"ProductCode":"0000010593",
      # "Quantity":11,"TotalPrice":1199,"TotalPriceDiscounted":1199,"MarketProgramId":0},
      # {"ProductCode":"0000014875","Quantity":1,"TotalPrice":10,"TotalPriceDiscounted":10,"MarketProgramId":0}],
      # "SiteOrderCode":"185"}

      def finalize_order(order)
        post '/api/processing/sale', order_params(order, 1)
      end

      private

      def order_params(order, document_type)
        new = camel_case(order)
        { DocumentDateTime: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
          ProcV2: true,
          DocumentType: document_type,
          DocumentDiscountDtos: new.delete(:discount),
          DocumentDetailDtos: new.delete(:order_items) }.merge(new)
      end

    end

  end
end