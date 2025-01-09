# frozen_string_literal: true

# Service bus stop handling, including prediction retrieval via `BusTime::Api`
class BusTime::BusStop
  attr_reader :id, :name, :lat, :lon

  attr_writer :predictions

  attr_accessor :direction, :routes

  def initialize(id, name, coords:, direction:, routes: [])
    @id = id
    @name = name
    @lat, @lon = coords
    @direction = direction

    @routes = routes
  end

  def predictions
    @predictions || fetch_predictions
  end

  def fetch_predictions
    @predictions = BusTime.api.fetch_predictions(@id)
  end

  def distance_from(lat, lon)
    Geocoder::Calculations.distance_between([@lat, @lon], [lat, lon])
  end

  def nearby?(lat, lon, max_nearby_distance = BusTime.nearby_distance)
    distance_from(lat, lon) <= max_nearby_distance
  end
end
