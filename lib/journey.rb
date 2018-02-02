class Journey

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

  # def current_journey
  #   {:entry_station => @entry_station, :exit_station => @exit_station}
  # end

private

  def change_complete_status
    if !!entry_station && !!exit_station
      @complete = true
    end
  end


end
