require_relative 'journey'

class JourneyLog

  attr_reader :journey_class, :journeys, :current_journey, :oystercard

  def initialize(journey_class, oystercard)
    @journey_class = journey_class
    @journeys = []
    @current_journey = nil
    @oystercard = oystercard
  end

  def start(entry_station)
    incomplete_journey_penalty if @current_journey
    create_current_journey
    @current_journey.start(entry_station)
  end

  def finish(exit_station)
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
    @oystercard.deduct(@current_journey.fare)
    add_journey
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
