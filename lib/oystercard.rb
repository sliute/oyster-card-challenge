require_relative "station.rb"
require_relative "journey.rb"

class Oystercard

  attr_reader :balance, :journeys, :current_journey

  MAX_BALANCE = 90

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
    incomplete_journey_penalty if @current_journey
    create_current_journey
    @current_journey.start(entry_station)
  end

  def touch_out(exit_station)
    @current_journey ? complete_current_journey(exit_station) : no_current_journey_penalty(exit_station)
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
    empty_current_journey
  end

  def complete_current_journey(exit_station)
    @current_journey.finish(exit_station)
    deduct(@current_journey.fare)
    add_journey
  end

  def exceeds_max_balance?(top_up_amt)
    (balance + top_up_amt) > MAX_BALANCE
  end

  def has_sufficient_balance?
    balance >= Journey::MIN_FARE
  end

  def deduct(deduct_amt)
    @balance -= deduct_amt
  end

  def incomplete_journey_penalty
    @current_journey.finish(nil)
    deduct(@current_journey.fare)
    empty_current_journey
  end

  def no_current_journey_penalty(exit_station)
    create_current_journey
    complete_current_journey(exit_station)
  end

end
