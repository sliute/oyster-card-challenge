require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:station) { instance_double("Station") }

  context "on initialisation" do
    it { is_expected.not_to be_in_journey }
  end

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

  describe '#in_journey?' do
    context 'new oystercards' do
      it { is_expected.not_to be_in_journey}
    end
  end

  min_journey_balance = described_class::MIN_JOURNEY_BALANCE
  describe "#touch_in" do
    context "balance is MIN_JOURNEY_BALANCE + 10" do
      before(:each) do
        oystercard.top_up(min_journey_balance+ 10)
        oystercard.touch_in(station)
      end
      it 'in_journey is true once touched in' do
        is_expected.to be_in_journey
      end
      it "remembers the touch in station" do
        expect(oystercard.entry_station).to eq station
      end
      context "already touched in" do
        it "raises error" do
            message = "Cannot touch in, already touched in!"
            expect{oystercard.touch_in(subject)}.to raise_error(RuntimeError, message)
        end
      end
    end
    context "insufficient balance" do
      it "raises error" do
        message = "Cannot touch in, you do not have sufficient balance!"
        oystercard.top_up(min_journey_balance - 0.01)
        expect{oystercard.touch_in(station)}.to raise_error(RuntimeError, message)
      end
    end
  end

  describe "#touch_out" do
    before(:each) do
      oystercard.top_up(min_journey_balance+ 10)
    end
    it "in_journey is false once touched out" do
      oystercard.touch_in(station)
      oystercard.touch_out
      is_expected.not_to be_in_journey
    end

    it "entry_station is nil once touched out" do
      oystercard.touch_in(station)
      oystercard.touch_out
      expect(oystercard.entry_station).to eq nil
    end

    it 'deducts the journey fare from the oystercard balance' do
      oystercard.touch_in(station)
      expect { oystercard.touch_out}.to change{oystercard.balance}.by(-1)
    end

    context "already touched out" do
      it 'raise error' do
        message = 'Cannot touch out, already touched out!'
        expect { oystercard.touch_out }.to raise_error(RuntimeError, message)
      end
    end
  end
end
