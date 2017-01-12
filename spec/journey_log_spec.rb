require 'journey_log'


describe JourneyLog do

  let(:journey_class) { Journey }
  let(:oystercard) { instance_double("Oystercard") }
  subject(:journey_log) { described_class.new(journey_class, oystercard) }



  describe "#initialize" do
    context "testing #new on class" do
      subject(:journey_log_class) { described_class }
      it { is_expected.to respond_to(:new).with(2).arguments }
    end
    it "has a journey_class" do
      expect(journey_log.journey_class).to eq Journey
    end
    it "has an empty journeys array" do
      expect(journey_log.journeys).to be_empty
    end
    it 'initializes with empty current journey' do
      expect(journey_log.current_journey).to be_nil
    end
  end

  describe "#start + #current_journey" do
    it "creates a @current_journey" do
      pending 'refactor'
      expect(oystercard.current_journey).to be_a(Journey)
    end
    context "with incomplete journey" do
      it "charges penalty" do
        pending 'refactor'
        expect{oystercard.touch_in(entry_station)}.to change{oystercard.balance}.by(-penalty_fare)
      end
    end
  end

  describe "#finish" do
    it "journeys array count increased by 1" do
      pending 'refactor'
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.journeys.count}.by 1
    end
    it 'stores a journey in journeys' do
      pending 'refactor'
      expect(oystercard.journeys[-1]).to be_a(Journey)
    end
    context "with no current journey" do
      it 'charge penalty' do
        pending 'refactor'
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-penalty_fare)
      end
    end

    it 'deducts the journey fare from the oystercard balance' do
      pending 'refactor'
      expect {oystercard.touch_out(exit_station) }.to change{oystercard.balance}.by(-min_journey_balance)
    end

  end




end
