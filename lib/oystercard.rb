require_relative "station.rb"
require_relative "journey.rb"
require_relative "journey_log.rb"

class Oystercard

  attr_reader :balance, :current_journey, :journey_log # :journeys

  MAX_BALANCE = 90

  def initialize
    @balance = 0
    @current_journey = nil
    # @journeys = []
    @journey_log = JourneyLog.new(Journey, self)
  end

  def top_up(top_up_amt)
    raise 'Balance cannot exceed 90' if exceeds_max_balance?(top_up_amt)
    @balance += top_up_amt
  end

  def deduct(deduct_amt)
    @balance -= deduct_amt
  end

  def touch_in(entry_station)
    fail 'Cannot touch in, you do not have sufficient balance!' unless has_sufficient_balance?
    @journey_log.start(entry_station)
  end

  def touch_out(exit_station)
    @journey_log.finish(exit_station)
  end

  private

  def exceeds_max_balance?(top_up_amt)
    (balance + top_up_amt) > MAX_BALANCE
  end

  def has_sufficient_balance?
    balance >= Journey::MIN_FARE
  end

end
