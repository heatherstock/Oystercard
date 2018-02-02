require_relative "station"
require_relative "journey"

class Oystercard

  DEFAULT_BALANCE = 0
  MINIMUM_BALANCE = 1
  DEFAULT_LIMIT = 90
  PENALTY = MINIMUM_BALANCE * 6
  attr_reader :balance, :journey_history, :journey

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journey_history = []
    @journey = nil
  end

  def top_up(amount)
    raise "Maximum balance of #{DEFAULT_LIMIT} exceeded" if limit_reached?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Minimum balance not met" if @balance < MINIMUM_BALANCE
    entry_fare
    @journey = Journey.new
    @journey.start(entry_station)
  end

  def touch_out(exit_station)
    @journey = Journey.new if @journey == nil
    @journey.finish(exit_station)
    deduct(@journey.exit_fare)
    save_journey
    @journey = nil
  end

  private

  def limit_reached?(amount)
    (@balance + amount) > DEFAULT_LIMIT
  end

  def entry_fare
    @balance -= PENALTY if @journey != nil
  end

  def deduct(fare)
    @balance -= fare
  end

  def save_journey
    @journey_history << @journey
  end

end
