require 'station'

describe Station do
  let(:station) {described_class.new("borough", 1)}
  context 'on initialisation' do
    it 'has a name instance variable' do
      expect(station.name).to eq "borough"
    end
    it 'has a zone instance variable' do
      expect(station.zone).to eq 1
    end
  end
end
