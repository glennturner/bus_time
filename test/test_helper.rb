require "test/unit"
require "webmock/test_unit"
require "bus_time"

module BusTime
  class Test::Unit::TestCase
    def setup
      @bus_time = BusTime.connection("FAKE_API_KEY")

      stub_routes
    end

    def stub_routes
      route = expected_route
      route_id = route["rt"]

      stub_request_action("getroutes").to_return(
        body: JSON.generate(expected_routes_body)
      )

      stub_request_action("getdirections", { rt: route_id }).to_return(
        body: JSON.generate(expected_directions_body)
      )

      expected_directions.each do |direction|
        stub_request_action("getstops", { rt: route_id, dir: direction["dir"] }).to_return(
          body: JSON.generate(expected_stops_body)
        )
      end
    end

    def stub_request_action(action, params = {})
      stub_request(:get, @bus_time.send(:request_uri, action, params))
    end

    def expected_routes_body
      {
        BusTime::Api::BASE_RESPONSE_PROP => {
          "routes" => [
            {"rt"=>"52", "rtnm"=>"Kedzie", "rtclr"=>"#996633", "rtdd"=>"52"}
          ]
        }
      }
    end

    def expected_directions_body
      {
        BusTime::Api::BASE_RESPONSE_PROP => {
          "directions" => [{"dir"=>"Northbound"}, {"dir"=>"Southbound"}]
        }
      }
    end

    def expected_directions
      expected_directions_body[BusTime::Api::BASE_RESPONSE_PROP]["directions"]
    end

    def expected_stops_body
      {
        BusTime::Api::BASE_RESPONSE_PROP => {
          "stops" => [
            {
              "stpid" => "3133",
              "stpnm" => "3201 S Kedzie",
              "lat" => 41.835209999999,
              "lon" => -87.704715
            }
          ]
        }
      }
    end

    def expected_stops
      expected_directions_body[BusTime::Api::BASE_RESPONSE_PROP]["directions"]
    end


    def expected_routes
      expected_routes_body[BusTime::Api::BASE_RESPONSE_PROP]["routes"]
    end

    def expected_route
      expected_routes.first
    end

    def expected_route_ids
      expected_routes.map { |route| route["rt"] }
    end
  end
end
