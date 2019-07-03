module Rxloyalty
  class Client

    module Cards

      def disable_card_accumulate(client_id, card_code)
        params = { ClientId: client_id, Cards: [{ "CardCode": card_code, "AccumulateOnly": false }] }
        post "/SiteController/SetProfileInfo?LicenseGuid=#{@options[:LicenseGuid]}", params
      end

      def cancel_card(card_code)
        post '/api/siteprocessing/cancel', CardCode: card_code
      end

      def card_info(card_code)
        post '/api/siteprocessing/info', CardCode: card_code
      end

      def register_card(card_code)
        post '/api/siteprocessing/register', CardCode: card_code
      end

      def update_profile(params)
        post "/SiteController/SetProfileInfo?LicenseGuid=#{@options[:LicenseGuid]}", params
      end

    end

  end
end