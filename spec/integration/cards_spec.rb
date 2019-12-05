require 'spec_helper'

RSpec.describe Rxloyalty::Client::Cards, :vcr, integration: true do

  subject { Rxloyalty::Client.new('f61d8b6a-a93c-4730-b7de-198e50109c8a') }

  describe '#card_info' do

    it 'return cart info by cart number' do
      response = subject.card_info(@qwerty)
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
      response = subject.disable_card_accumulate(26144, @qwerty)
      expect(response["ClientId"]).to eq 26144
    end

  end

end