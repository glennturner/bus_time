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

      @bus_time.get_routes.each { |route|
        assert_include expected_route_ids, route.id
      }
    end

    def test_get_route_by_id
      route_id = expected_route_ids.first
      expected_directions_body = {
        "bustime-response" => {
          "directions" => [{"dir"=>"Northbound"}, {"dir"=>"Southbound"}]
        }
      }

      stub_request_action("getroutes").to_return(
        body: JSON.generate(expected_routes_body)
      )

      stub_request_action("getdirections", { rt: route_id }).to_return(
        body: JSON.generate(expected_directions_body)
      )

      route = @bus_time.get_route(route_id)
      p route
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
