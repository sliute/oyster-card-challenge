require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let(:entry_station) { instance_double("Station") }
  let(:exit_station) { instance_double("Station") }

  describe "#initialize" do
    it 'with empty entry' do
      expect(journey.entry_station).to be_nil
    end

    it 'with empty exit' do
      expect(journey.exit_station).to be_nil
    end
  end

  describe "#start" do
    it 'inserts the entry station' do
      journey.start(entry_station)
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe "#finish" do
    it 'inserts the exit station' do
      journey.finish(exit_station)
      expect(journey.exit_station).to eq exit_station
    end
  end

  describe "#complete?" do
    it 'checks the journey is complete' do
      journey.start(entry_station)
      journey.finish(exit_station)
      expect(journey).to be_complete
    end
  end

  describe '#fare' do
    context "fare calculation" do
      before(:each) do
        journey.start(entry_station)
        journey.finish(exit_station)
      end

      it 'returns the fare of £1 when within same zone' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 2 }
        expect(journey.fare).to eq 1
      end
      it 'returns the fare of £2 when travelled 1 zone' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 3 }
        expect(journey.fare).to eq 2
      end
      it 'returns the fare of £3 when travelled 2 zones' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 4 }
        expect(journey.fare).to eq 3
      end
      it 'returns the fare of £4 when travelled 3 zones' do
        allow(entry_station).to receive(:zone) { 2 }
        allow(exit_station).to receive(:zone) { 5 }
        expect(journey.fare).to eq 4
      end
      it 'returns the fare of £5 when travelled 4 zones' do
        allow(entry_station).to receive(:zone) { 6 }
        allow(exit_station).to receive(:zone) { 2 }
        expect(journey.fare).to eq 5
      end
    end

    it 'returns penalty when not touched out' do
      journey.start(entry_station)
      expect(journey.fare).to eq described_class::PENALTY_FARE
    end

    it 'returns penalty when not touched in' do
      journey.finish(exit_station)
      expect(journey.fare).to eq described_class::PENALTY_FARE
    end

  end

end
