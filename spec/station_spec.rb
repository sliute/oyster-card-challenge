require 'station'

describe Station do
  let(:station) {described_class.new("borough", 1)}
  context 'on initialisation' do
    it 'has a name instance variable' do
      expect(station.name).not_to be_nil
    end
    it 'has a zone instance variable' do
      expect(station.zone).not_to be_nil
    end





  end

end
