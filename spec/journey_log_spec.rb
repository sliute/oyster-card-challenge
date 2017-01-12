require 'journey_log'

describe JourneyLog do

  let(:journey_class) { Journey }
  subject(:journey_log) { described_class.new(journey_class) }



  describe "#initialize" do
    context "testing #new on class" do
      subject(:journey_log_class) { described_class }
      it { is_expected.to respond_to(:new).with(1).argument }
    end
    it "has a journey_class" do
      expect(journey_log.journey_class).to eq Journey
    end
    it "has an empty journeys array" do
      expect(journey_log.journeys).to be_empty
    end
  end




end
