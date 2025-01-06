require "test/unit"
require "webmock/test_unit"
require "bus_time"

module BusTime
  class Test::Unit::TestCase
    def setup
      @bus_time = BusTime.connection("FAKE_API_KEY")
    end

    def stub_request_action(action, params = {})
      stub_request(:get, @bus_time.send(:request_uri, action, params))
    end

    def expected_routes_body
      {
        BusTime::Api::BASE_RESPONSE_PROP => {
          "routes" => [
            {"rt"=>"52", "rtnm"=>"Kedzie", "rtclr"=>"#996633", "rtdd"=>"52"},
            {"rt"=>"52A", "rtnm"=>"South Kedzie", "rtclr"=>"#ff0066", "rtdd"=>"52A"}
          ]
        }
      }
    end

    def expected_routes
      expected_routes_body[BusTime::Api::BASE_RESPONSE_PROP]["routes"]
    end

    def expected_route_ids
      expected_routes.map { |route| route["rt"] }
    end
  end
end
