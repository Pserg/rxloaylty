require 'spec_helper'

RSpec.describe Rxloyalty::Client::Orders, :vcr, integration: true do

  SITE_ORDER_CODE = 523_122

  subject { Rxloyalty::Client.new('f61d8b6a-a93c-4730-b7de-198e50109c8a') }

  describe '#orders' do

    it 'return array of client orders by card number' do
      doc_ids = [99_226, 145_940, 145_942, 227_177, 259_639, 359_973,
                 390_723, 419_373, 480_751, 485_879, 503_862]
      response = subject.orders('2018100037015')
      expect(response[:success]).to be_truthy
      expect(response[:data].map { |doc| doc[:document_id] }).to eq doc_ids
    end

  end

  describe '#register_order' do
    it 'register the order in the processing for bonus calculation' do
      params = [{ PositionId: '1', ProductCode: 'c8644e9a-7be7-11e9-0b93-e2feabc01182',
                  TotalPrice: 3000, Quantity: 6, Properties: {} }]
      response = subject.register_order('2018100000088', params)
      register_detail_response_dtos = [{ position_id: '1', discount: 3000.0,
                                         use_percent: false, can_spend_bonus: true,
                                         special_price: 0.0,
                                         special_price_quantity: 0.0,
                                         end_price: 0.0, market_program_id: 0,
                                         market_program_is_forced: false,
                                         alternative_discount_dtos: [] }]
      expect(response[:success]).to be_truthy
      expect(response[:register_detail_response_dtos]).to eq register_detail_response_dtos
    end
  end

  describe '#sale_order' do
    it 'create sale document in processing for bonus holding' do
      params = { cashier_name: '', document_type: 12,
                 document_code: rand(123_456).to_s,
                 total_sum: 74, total_sum_discounted: 74,
                 discount: [{ account_id: 36_891,
                              card_code: '2018103099010',
                              sum_base: 74,
                              sum_discounted: 74,
                              discount: 0,
                              percent: 0 }],
                 order_items: [{
                   product_code: '00001761',
                   quantity: 2,
                   total_price: 74,
                   total_price_discounted: 74,
                   market_program_id: 0
                 }],
                 used_gifts: [],
                 site_order_code: SITE_ORDER_CODE }
      response = subject.sale_order(params)

      sale_discount_response_dtos = [{ account_id: 36_891,
                                       card_code: '2018103099010',
                                       account_type_id: 1, add_bonus: 0.0,
                                       remove_bonus: 0.0, balance: 30.0,
                                       client_status: nil }]

      expect(response[:success]).to be_truthy
      expect(response[:sale_discount_response_dtos]).to eq sale_discount_response_dtos
    end
  end

  describe '#cancel_order' do

    it 'cancel order in processing after sale for give back bonuses' do
      response = subject.cancel_order(SITE_ORDER_CODE)
      expect(response[:success]).to be_truthy
    end
  end

end