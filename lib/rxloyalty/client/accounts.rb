module Rxloyalty
  class Client
    module Accounts

      OPTIONAL_UPDATE_FIELDS = %w[AcountId Balance AccountType ClientChipInfo].freeze

      def login(login:, password:)
        post "/Account/Login", { Login: login, Password: password }
      end

      def update_profile(params)
        post "/SiteController/SetProfileInfo?LicenseGuid=#{@options[:LicenseGuid]}",
             camel_case(params)
      end

      private

      def handle_update_params(params)
        params['AccumulateOnly'] = false
        params.reject { |key, _| OPTIONAL_UPDATE_FIELDS.include?(key) }
      end

    end
  end
end