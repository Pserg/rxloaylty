require 'spec_helper'

RSpec.describe Rxloyalty::Client::Orders, :vcr, integration: true do

  subject { Rxloyalty::Client.new('5205F9B5-2CF8-4866-AE63-BA178F40651A') }

  describe '#orders' do

    it 'return array of card client orders' do
      doc_ids = [2899, 3033, 3126, 3564, 5492, 7283, 7790, 8407, 8526, 8695, 9413,
                 10_393, 12_199, 12_341, 13_182]
      response = subject.orders('2900010000046')
      expect(response.map { |doc| doc['DocumentId'] }).to eq doc_ids
    end

  end

end