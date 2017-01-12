require 'oystercard'
require 'journey'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { instance_double("Station") }
  let(:exit_station) { instance_double("Station") }
  let(:journey) { instance_double("Journey") }
  let(:journey_log) { instance_double("JourneyLog") }

  min_journey_balance = Journey::MIN_FARE
  penalty_fare = Journey::PENALTY_FARE

  describe "#initialize" do
    it 'has an empty journeys log' do
      allow(journey_log).to receive(:journeys) { [] }
      expect(oystercard.journey_log.journeys).to be_empty
    end
    it 'balance is 0' do
      expect(oystercard.balance).to eq 0
    end
    it "is not in current journey" do
      expect(oystercard.current_journey).to be_nil
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

  describe "#touch_in" do
    context "with sufficient balance" do
      before(:each) do
        oystercard.top_up(min_journey_balance+ 10)
        oystercard.touch_in(entry_station)
      end
      it "creates a @current_journey" do
        expect(oystercard.current_journey).to be_a(Journey)
      end
      context "with incomplete journey" do
        it "charges penalty" do
          expect{oystercard.touch_in(entry_station)}.to change{oystercard.balance}.by(-penalty_fare)
        end
      end
    end
    context "with insufficient balance" do
      it "raises error" do
        message = "Cannot touch in, you do not have sufficient balance!"
        oystercard.top_up(min_journey_balance - 0.01)
        expect{oystercard.touch_in(entry_station)}.to raise_error(RuntimeError, message)
      end
    end
  end

  describe "#touch_out" do
    before(:each) do
      oystercard.top_up(min_journey_balance+ 10)
      oystercard.touch_in(entry_station)
    end
    context "have touched in" do
      it "journeys array count increased by 1" do
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.journeys.count}.by 1
      end
    end
    context "have touched in and out" do
      before(:each) do
        oystercard.touch_out(exit_station)
      end
      it 'stores a journey in journeys' do
        expect(oystercard.journeys[-1]).to be_a(Journey)
      end
      context "with no current journey" do
        it 'charge penalty' do
          expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-penalty_fare)
        end
      end
    end
    it 'deducts the journey fare from the oystercard balance' do
      expect {oystercard.touch_out(exit_station) }.to change{oystercard.balance}.by(-1)
    end
  end
end
