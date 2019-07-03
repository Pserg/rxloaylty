require 'spec_helper'

RSpec.describe Rxloyalty::Client::Cards, :vcr, integration: true do

  subject { Rxloyalty::Client.new('5205F9B5-2CF8-4866-AE63-BA178F40651A') }

  describe '#card_info' do

    it 'return cart info by cart number' do
      response = subject.card_info('2900010000015')
      expect(response['CardStatus']).to eq 'Активна'
    end

  end

  describe '#update_profile' do

    it 'return update profile for card user' do
      response = subject.update_profile(ClientId: 26144, FirstName: 'Some name')
      expect(response['FirstName']).to eq 'Some name'
    end

  end

  describe '#disable_card_accumulate' do

    it 'set card accumulate to false' do
      response = subject.disable_card_accumulate(26144, '2900010000015')
      expect(response["ClientId"]).to eq 26144
    end

  end

end