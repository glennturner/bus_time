# frozen_string_literal: true

# Service bus routes handling, including direction and stop retrieval
# via `BusTime::Api`
class BusTime::BusRoute
  attr_reader :id, :name

  attr_writer :directions, :stops

  def initialize(id, name)
    @id = id
    @name = name
  end

  def directions
    @directions || fetch_directions
  end

  def stops
    @stops || fetch_stops
  end

  def fetch_directions
    @directions = BusTime.api.fetch_directions(@id)
  end

  def fetch_stops
    @directions.each do |direction|
      @stops = BusTime.api.fetch_stops(@id, direction)
    end
  end

  def display_name
    "#{@id} - #{@name}"
  end

  def nearby_stops(_lat, _lon, _radius = DEFAULT_NEARBY_DISTANCE)
    @stops.select do |stop|
      # stop.distanceFrom(lat, lon) <= radius
      stop
    end
  end
end
