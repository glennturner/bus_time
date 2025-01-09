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

    register_stub_request_action("getroutes", expected_body("routes"))
    register_stub_request_action("getdirections", expected_body("directions"), params: { rt: route_id })

    expected_directions.each do |direction|
      register_stub_request_action("getstops", expected_body("stops"),
                                   params: {
                                     rt: route_id,
                                     dir: direction["dir"]
                                   })
    end
  end

  def register_stub_request_action(action, expected_response_body, params: {})
    stub_request_action(action, params).to_return(
      body: JSON.generate(expected_response_body)
    )
  end

  def stub_request_action(action, params = {})
    stub_request(:get, @bus_time.send(:request_uri, action, params))
  end

  def expected_body(request_type)
    parent_keys = {
      "routes" => "routes",
      "directions" => "directions",
      "stops" => "stops",
      "predictions" => "prd"
    }

    {
      BusTime::Api::BASE_RESPONSE_PROP => {
        parent_keys[request_type] => send(:"expected_#{request_type}")
      }
    }
  end

  def expected_routes
    [
      {
        "rt" => "52", "rtnm" => "Kedzie",
        "rtclr" => "#996633", "rtdd" => "52"
      }
    ]
  end

  def expected_route
    expected_routes.first
  end

  def expected_route_ids
    expected_routes.map { |route| route["rt"] }
  end

  def expected_directions
    [
      {
        "dir" => "Northbound"
      },
      {
        "dir" => "Southbound"
      }
    ]
  end

  def expected_predictions
    [
      {
        "rt" => "52",
        "rtdir" => "Northbound",
        "stpid" => "3133",
        "prdctdn" => "5",
        "typ" => "A",
        "dly" => false,
        "stpnm" => "3201 S Kedzie",
        "prdtm" => (Time.now + 300).strftime(BusTime::DEFAULT_TS_FORMAT),
        "tmstmp" => Time.now.strftime(BusTime::DEFAULT_TS_FORMAT)
      }
    ]
  end

  def expected_stops
    [
      {
        "stpid" => "3133",
        "stpnm" => "3201 S Kedzie",
        "lat" => 41.835209999999,
        "lon" => -87.704715
      },
      {
        "stpid" => "14787",
        "stpnm" => "Clark & Balmoral",
        "lat" => 41.979684999999,
        "lon" => -87.668331999999
      }
    ]
  end
end
