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
    before(:each){oystercard.top_up(20)}

    describe "#touch_in" do
      it "creates a new instance of Journey" do
        oystercard.touch_in(entry_station)
        expect(oystercard.journey).to be_instance_of(Journey)
      end

      it "deducts penalty fare from card balance" do
        oystercard.touch_in(entry_station)
        expect{oystercard.touch_in(entry_station)}.to change{oystercard.balance}.by(-Oystercard::PENALTY)
      end
    end

    describe "#touch_out" do
      it "deducts normal fare from the card balance" do
        oystercard.touch_in(entry_station)
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Oystercard::MINIMUM_BALANCE)
      end

      it "deducts penalty fare from the card balance" do
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-Oystercard::PENALTY)
      end

      it "stores current journey in array" do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.journey_history.last).to be_instance_of(Journey)
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

end
