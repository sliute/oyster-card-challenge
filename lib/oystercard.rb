class Oystercard

  attr_reader :balance, :in_journey, :entry_station
  alias_method :in_journey?, :in_journey

  MAX_BALANCE = 90
  MIN_JOURNEY_BALANCE = 1

  def initialize
    @balance = 0
    @in_journey = false
    @entry_station = nil
  end

  def top_up(top_up_amt)
    raise 'Balance cannot exceed 90' if exceeds_max_balance?(top_up_amt)
    @balance += top_up_amt
  end


  def touch_in(station)
    fail 'Cannot touch in, you do not have sufficient balance!' unless has_sufficient_balance?
    fail 'Cannot touch in, already touched in!' if in_journey?
    @in_journey = true
    @entry_station = station
  end

  def touch_out(station)
    fail 'Cannot touch out, already touched out!' unless in_journey?
    @in_journey = false
    deduct(1)
    @entry_station = nil
  end

private

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
