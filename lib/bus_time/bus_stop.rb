module BusTime
  class BusStop
    attr_reader :id, :name, :lat, :lon, :predictions

    attr_accessor  :direction, :routes

    def initialize(id, name, coords:, direction:, routes: [])
      @id = id
      @name = name
      @lat, @lon = coords
      @direction = direction

      @routes = routes
    end

    def predictions
      @predictions || get_predictions
    end

    def get_predictions
      @predictions = BusTime.api.get_predictions(@id)
    end

    def distance_from(lat, lon)
      Geocoder::Calculations.distance_between([ @lat, @lon ], [ lat, lon ])
    end
  end
end
