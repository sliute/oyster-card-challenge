require_relative "station.rb"
require_relative "journey.rb"

class Oystercard

  attr_reader :balance, :entry_station, :journeys, :exit_station, :current_journey

  MAX_BALANCE = 90
  MIN_JOURNEY_BALANCE = 1

  def initialize
    @balance = 0
    @entry_station = nil
    @exit_station = nil
    @current_journey = nil
    @journeys = []
  end

  def top_up(top_up_amt)
    raise 'Balance cannot exceed 90' if exceeds_max_balance?(top_up_amt)
    @balance += top_up_amt
  end


  def touch_in(entry_station)
    fail 'Cannot touch in, you do not have sufficient balance!' unless has_sufficient_balance?
    # @entry_station = entry_station
    #@exit_station = nil
    @current_journey = Journey.new
    @current_journey.start(entry_station)
  end

  def touch_out(exit_station)
    deduct(1)
    @exit_station = exit_station
    add_journey
    @entry_station = nil
  end

  # def in_journey?
  #   entry_station ? true : false
  # end

private

  def add_journey
    @journeys << @current_journey
  end

  def exceeds_max_balance?(top_up_amt)
    (balance + top_up_amt) > MAX_BALANCE
  end

  def has_sufficient_balance?
    balance >= MIN_JOURNEY_BALANCE
  end

  def deduct(deduct_amt)
    @balance -= deduct_amt
  end

end
