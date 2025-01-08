module BusTime
  class BusRoute
    attr_reader :id, :name

    attr_accessor :directions, :stops

    def initialize(id, name)
      @id = id
      @name = name
    end

    def directions
      @directions || get_directions
    end

    def stops
      @stops || get_stops
    end

    def get_directions
      @directions = BusTime.api.get_directions(@id)
    end

    def get_stops
      @directions.each do |direction|
        @stops = BusTime.api.get_stops(@id, direction)
      end
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
