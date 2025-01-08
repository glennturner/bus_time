module BusTime
  class BusStop
    attr_reader :id, :name, :lat, :lon

    attr_accessor  :direction, :predictions, :routes

    def initialize(id, name, coords:, direction:, predictions: [], routes: [])
      @id = id
      @name = name
      @lat, @lon = coords

      @predictions = predictions
      @routes = routes
      @direction = direction
    end

    def get_predictions
      @predictions = BusTime.api.get_predictions(@id)
    end

    def distance_from(lat, lon)
      Geocoder::Calculations.distance_between([ @lat, @lon ], [ lat, lon ])
    end
  end
end
