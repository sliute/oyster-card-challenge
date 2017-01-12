require_relative "station.rb"
require_relative "journey.rb"

class Oystercard

  attr_reader :balance, :journeys, :current_journey

  MAX_BALANCE = 90
  MIN_JOURNEY_BALANCE = 1

  def initialize
    @balance = 0
    @current_journey = nil
    @journeys = []
  end

  def top_up(top_up_amt)
    raise 'Balance cannot exceed 90' if exceeds_max_balance?(top_up_amt)
    @balance += top_up_amt
  end


  def touch_in(entry_station)
    fail 'Cannot touch in, you do not have sufficient balance!' unless has_sufficient_balance?
    create_current_journey
    @current_journey.start(entry_station)
  end

  def touch_out(exit_station)
    deduct(1)
    @current_journey.finish(exit_station)
    add_journey
    empty_current_journey
  end

  private

  def create_current_journey
    @current_journey = Journey.new
  end

  def empty_current_journey
    @current_journey = nil
  end

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
