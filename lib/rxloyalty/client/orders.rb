module Rxloyalty
  class Client

    module Orders

      def orders(card_code)
        post '/SiteController/DocHistory', CardCode: card_code
      end

    end

  end
end