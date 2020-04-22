module Rxloyalty
  class Client
    module Cards

      def disable_card_accumulate(card_code:)
        params = card_info(card_code, false)
        post "/SiteController/SetProfileInfo?LicenseGuid=#{@options[:LicenseGuid]}",
             handle_update_params(params)
      end

      def cancel_card(card_code)
        post '/api/processing/cancel', CardCode: card_code
      end

      def card_info(card_code, convert = true)
        post '/api/processing/info', { CardCode: card_code }, convert
      end

      def register_card(card_code)
        post '/api/processing/register', CardCode: card_code
      end

      def personal_discounts(card_code)
        post '/SiteController/PersonalDiscount', CardCode: card_code
      end

    end
  end
end