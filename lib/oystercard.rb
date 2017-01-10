class Oystercard

  attr_reader :balance, :in_journey
  alias_method :in_journey?, :in_journey

  MAX_BALANCE = 90

  def initialize
    @balance = 0
  end

  def top_up(top_up_amt)
    raise 'Balance cannot exceed 90' if exceeds_max_balance?(top_up_amt)
    @balance += top_up_amt
  end

  def deduct(deduct_amt)
    @balance -= deduct_amt
  end

private

  def exceeds_max_balance?(top_up_amt)
    (balance + top_up_amt) > MAX_BALANCE
  end

end
