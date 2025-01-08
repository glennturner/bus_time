require "test_helper"

module BusTime
  class BusTimeTest < Test::Unit::TestCase
    def test_get_time
      service_time = "20250104 21:35:14"
      expected_body = {
        "bustime-response" => {
          "tm" => service_time
        }
      }

      stub_request_action("gettime").to_return(
        body: JSON.generate(expected_body)
      )

      assert_equal service_time, @bus_time.get_time
    end

    def test_get_routes
      stub_request_action("getroutes").to_return(
        body: JSON.generate(expected_routes_body)
      )

      routes = @bus_time.get_routes
      assert_not_empty routes

      routes.each { |route|
        assert_include expected_route_ids, route.id
      }
    end

    def test_get_route_by_id
      route_id = expected_route["rt"]
      route = @bus_time.get_route(route_id)

      assert_equal route_id, route.id
      assert_not_empty route.directions
    end

    def test_get_stops
      route = expected_route
      route_id = route["rt"]
      direction = expected_directions.first["dir"]
      stub_request_action("getstops", {
        rt: route_id,
        dir: direction
      }).to_return(
        body: JSON.generate(expected_stops_body)
      )

      stops = @bus_time.get_stops(route_id, direction)

      assert_not_empty stops
      stops.each do |stop|
        assert_include stop.routes, route_id
        assert_equal direction, stop.direction
      end
    end

    def test_bad_request_action
      action = "malformedrequest"
      stub_request_action("getroutes").to_return(
        status: 404
      )

      assert_raise ArgumentError do
        @bus_time.send(:request, action)
      end
    end
  end
end
