require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

  describe "#balance" do
    it 'initialises with a balance of 0' do
      expect(oystercard.balance).to eq 0
    end
  end

  describe "#top_up" do
    it 'tops up by a given amount' do
      expect(oystercard.top_up(10)).to eq oystercard.balance
    end

    it 'throws error if balance exceeds 90' do
      maximum_bal = described_class::MAX_BALANCE
      expect{ oystercard.top_up(91) }.to raise_error("Balance cannot exceed #{maximum_bal}")
    end
  end

  describe "#deduct" do
    it "deducts a given amount from the balance" do
        oystercard.top_up(50)
        oystercard.deduct(10)
        expect(oystercard.balance).to eq 40
    end
  end

  describe '#in_journey?' do
    context 'new oystercards' do
      it { is_expected.not_to be_in_journey}
    end
  end

  context "balance is MIN_JOURNEY_BALANCE + 10" do
    min_journey_balance = described_class::MIN_JOURNEY_BALANCE
    before(:each) do
      oystercard.top_up(min_journey_balance+ 10)
    end
    describe "#touch_in" do
      it 'in_journey is true once touched in' do
        oystercard.touch_in
        is_expected.to be_in_journey
      end
      context "already touched in" do
        it "raises error" do
          message = "Cannot touch in, already touched in!"
          oystercard.touch_in
          expect{oystercard.touch_in}.to raise_error(RuntimeError, message)
        end
      end
      context "insufficient balance" do
        it "raises error" do
          message = "Cannot touch in, you do not have sufficient balance!"
          oystercard.deduct(min_journey_balance + 9.01)
          expect{oystercard.touch_in}.to raise_error(RuntimeError, message)
        end
      end
    end

    describe "#touch_out" do
      it "in_journey is false once touched out" do
        oystercard.touch_in
        oystercard.touch_out
        is_expected.not_to be_in_journey
      end
      context "already touched out" do
        it 'raise error' do
          message = 'Cannot touch out, already touched out!'
          expect { oystercard.touch_out }.to raise_error(RuntimeError, message)
        end

      end
    end


  end


end
