require 'spec_helper'

RSpec.describe Rxloyalty::Client::Orders, :vcr, integration: true do

  subject { Rxloyalty::Client.new('f61d8b6a-a93c-4730-b7de-198e50109c8a') }

  describe '#orders' do

    it 'return array of card client orders' do
      doc_ids = [99226, 145940, 145942, 227177, 259639]
      response = subject.orders('2018100037015')
      expect(response.map { |doc| doc['DocumentId'] }).to eq doc_ids
    end

  end

  describe '#register_order' do
    it 'registers the card in the process after completing the entry of goods' do
      params = [{ PositionId: "1", ProductCode: "c8644e9a-7be7-11e9-0b93-e2feabc01182",
                  TotalPrice: 3000, Quantity: 6, Properties: {} }]
      response = subject.register_order('2018100000088', params)
      register_detail_response_dtos = [{"PositionId"=>"1", "Discount"=>3000.0,
                                        "UsePercent"=>false, "CanSpendBonus"=>true,
                                        "SpecialPrice"=>0.0, "SpecialPriceQuantity"=>0.0,
                                        "EndPrice"=>0.0, "MarketProgramId"=>0,
                                        "AlternativeDiscountDtos"=>[]}]
      #byebug
      expect(response["RegisterDetailResponseDtos"]).to eq register_detail_response_dtos
    end
  end

  describe '#cancel_order' do
    it 'unregistering a card in processing' do
      params = [{ "PositionId": "1", "ProductCode": "c8644e9a-7be7-11e9-0b93-e2feabc01182",
                  "TotalPrice": 3000, "Quantity": 6, "Properties": {} }]
      response = subject.cancel_order('2018100000088', params)
      expect(response).to eq true
    end
  end

  describe '#sale_order' do
    it 'sends a sales document to processing after closing a sale at the checkout' do
      params = { cashier_name: "", document_type: 12, document_code: "#{rand(123456)}",
                  total_sum: 74, total_sum_discounted: 74, discount: [{ account_id: 36891,
                                                                                      card_code: "2018103099010",
                                                                                      sum_base: 74,
                                                                                      sum_discounted: 74,
                                                                                      discount: 0,
                                                                                      percent: 0}],
                 order_items: [ {
                                              product_code: "00001761",
                                              quantity: 2,
                                              total_price: 74,
                                              total_price_discounted: 74,
                                              market_program_id: 0
                                          } ],
                  used_gifts: [],
                  site_order_code: rand(123456) }
      response = subject.sale_order(params)

      sale_discount_response_dtos = [{"AccountId"=>36891, "AccountTypeId"=>1, "AddBonus"=>0.0,
                                      "Balance"=>9.0, "CardCode"=>"2018103099010",
                                      "ClientStatus"=>nil, "RemoveBonus"=>0.0}]

      expect(response["SaleDiscountResponseDtos"]).to eq sale_discount_response_dtos
    end
  end

end