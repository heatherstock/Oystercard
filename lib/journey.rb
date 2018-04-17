class Journey

  MINIMUM_BALANCE = 1
  PENALTY = MINIMUM_BALANCE * 6

  attr_reader :entry_station, :exit_station, :in_journey

  def initialize
    @entry_station = nil
    @exit_station = nil
    @complete = false
  end

  def start(entry_station)
    @entry_station = entry_station
  end

  def finish(exit_station)
    @exit_station = exit_station
    change_complete_status
  end

  def complete?
    @complete
  end

  def exit_fare
    @entry_station == nil && @exit_station != nil ? PENALTY : MINIMUM_BALANCE
  end
  
private

  def change_complete_status
    if !!entry_station && !!exit_station
      @complete = true
    end
  end
end
