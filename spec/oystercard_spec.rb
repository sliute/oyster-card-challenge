require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

  describe ".balance" do
    it 'initialises with a balance of 0' do
      expect(oystercard.balance).to eq 0
    end
  end

  describe ".top_up" do
    it 'tops up by a given amount' do
      expect(oystercard.top_up(10)).to eq oystercard.balance
    end

    it 'throws error if balance exceeds 90' do
      maximum_bal = described_class::MAX_BALANCE
      expect{ oystercard.top_up(91) }.to raise_error("Balance cannot exceed #{maximum_bal}")
    end
  end

end
