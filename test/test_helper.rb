# frozen_string_literal: true

require "test/unit"
require "webmock/test_unit"
require "bus_time"

class BusTime::BusTimeTest < Test::Unit::TestCase
  def setup
    @bus_time = BusTime.connection("FAKE_API_KEY")

    stub_routes
  end

  def stub_routes
    route = expected_route
    route_id = route["rt"]

    register_stub_request_action("getroutes", expected_routes_body)
    register_stub_request_action("getdirections", expected_directions_body, params: { rt: route_id })

    expected_directions.each do |direction|
      register_stub_request_action("getstops", expected_stops_body, params: { rt: route_id, dir: direction["dir"] })
    end
  end

  def register_stub_request_action(action, expected_body, params: {})
    stub_request_action(action, params).to_return(
      body: JSON.generate(expected_body)
    )
  end

  def stub_request_action(action, params = {})
    stub_request(:get, @bus_time.send(:request_uri, action, params))
  end

  def expected_routes_body
    {
      BusTime::Api::BASE_RESPONSE_PROP => {
        "routes" => [
          {
            "rt" => "52", "rtnm" => "Kedzie",
            "rtclr" => "#996633", "rtdd" => "52"
          }
        ]
      }
    }
  end

  def expected_directions_body
    {
      BusTime::Api::BASE_RESPONSE_PROP => {
        "directions" => [{ "dir" => "Northbound" }, { "dir" => "Southbound" }]
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
