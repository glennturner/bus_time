module BusTime
  class BusRoute
    attr_reader :id, :name

    attr_writer :directions, :stops

    def initialize(id, name, stops: [], directions: [])
      @id = id
      @name = name
      @directions = directions
      @stops = stops
    end

    def display_name
      "#{@id} - #{@name}"
    end

    def nearby_stops(lat, lon, radius = DEFAULT_NEARBY_DISTANCE)
      @stops.select do |stop|
        # stop.distanceFrom(lat, lon) <= radius
        stop
      end
    end
  end
end
