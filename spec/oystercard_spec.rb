require 'oystercard'

describe Oystercard do
  subject(:oystercard) {described_class.new}
  let(:exit_station) {double('exit station')}
  let(:entry_station) {double('entry station')}
  # let(:journey) {double('journey')}

  context "when new oystercard is initialized with argument" do
    let(:oystercard20) { described_class.new(20) }
    it "has balance given" do
      expect(oystercard20.balance).to eq 20
    end
  end

  context "when new oystercard is initialized without argument" do
    it "has default balance" do
    expect(oystercard.balance).to eq Oystercard::DEFAULT_BALANCE
    end

    it "has empty journey history" do
      expect(oystercard.journey_history).to eq []
    end
  end

  context "when oystercard meets minimum balance" do
    before(:each){oystercard.top_up(Oystercard::MINIMUM_BALANCE)}

    describe "#touch_in" do
      it "sets entry station using new instance of journey" do
        expect(oystercard.touch_in(entry_station)).to eq entry_station
      end
    end

    describe "#touch_out" do
      before(:each){oystercard.touch_in(entry_station)}

      it "deducts fare from the card balance" do
        oystercard.touch_in(entry_station)
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Oystercard::MINIMUM_BALANCE)
      end

      let(:journey) {double("journey")}
      it "stores current journey in array" do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.journey_history).to include(journey)
      end
    end
  end

  context "when oystercard does not have minimum balance" do
    describe "#touch_in" do
      it "raises an error" do
        error_message = "Minimum balance not met"
        expect { oystercard.touch_in(entry_station) }.to raise_error error_message
      end
    end
  end

  describe "#top_up" do
    it "increases oystercard balance" do
      amount = 10
      expect{ oystercard.top_up(amount)}.to change{oystercard.balance}.by(amount)
    end
    it "raises error if maximum balance exceeded" do
      error_message = "Maximum balance of #{Oystercard::DEFAULT_LIMIT} exceeded"
      amount = Oystercard::DEFAULT_LIMIT - oystercard.balance + 1
      expect{ oystercard.top_up(amount) }.to raise_error error_message
    end
  end

    describe "#touch_out" do
    it "raises error if card hasn't been touched in" do
      error_message = "Not yet in journey"
      expect { oystercard.touch_out(exit_station) }.to raise_error error_message
    end
  end
end
