module BusTime
  class BusStop
    attr_reader :id, :name, :direction, :lat, :lon, :routes

    attr_accessor :predictions

    def initialize(id, name, direction:, lat:, lon:, predictions: [], routes: [])
      @id = id
      @name = name
      @lat = lat
      @lon = lon
      @predictions = predictions
      @routes = routes
      @direction = direction
    end

    def distanceFrom(lat, lon)
      #  getDistanceFromLatLonInKm(lat, lon, @lat, @lon)
    end
  end
end
