# frozen_string_literal: true

require "test_helper"

class BusTime::BusTimeTest < Test::Unit::TestCase
  test "fetch time" do
    service_time = "20250104 21:35:14"
    expected_time_body = {
      "bustime-response" => {
        "tm" => service_time
      }
    }

    stub_request_action("gettime").to_return(
      body: JSON.generate(expected_time_body)
    )

    assert_equal service_time, @bus_time.fetch_time
  end

  test "fetch routes" do
    stub_request_action("getroutes").to_return(
      body: JSON.generate(expected_body("routes"))
    )

    routes = @bus_time.fetch_routes
    assert_not_empty routes

    routes.each do |route|
      assert_include expected_route_ids, route.id
    end
  end

  test "fetch route by id" do
    route_id = expected_route["rt"]
    route = @bus_time.fetch_route(route_id)

    assert_equal route_id, route.id
    assert_not_empty route.directions
  end

  test "fetch stops" do
    route = expected_route
    route_id = route["rt"]
    direction = expected_directions.first["dir"]

    stub_request_action(
      "getstops", { rt: route_id, dir: direction }
    ).to_return(body: JSON.generate(expected_body("stops")))

    stops = @bus_time.fetch_stops(route_id, direction)
    assert_not_empty stops
    stops.each do |stop|
      assert_include stop.routes, route_id
      assert_equal direction, stop.direction
    end
  end

  test "fetch predictions" do
    stop_ids = expected_stop_ids

    stub_request_action(
      "getpredictions", { stpid: stop_ids }
    ).to_return(body: JSON.generate(expected_body("predictions")))

    predictions = @bus_time.fetch_predictions(stop_ids)

    assert_not_empty predictions
    assert_equal predictions.map(&:stop_id), stop_ids
  end

  test "fetch bulletins" do
    assert false, "Not implemented"
  end

  test "error raised on malformed request" do
    action = "malformedrequest"
    stub_request_action("getroutes").to_return(
      status: 404
    )

    assert_raise ArgumentError do
      @bus_time.send(:request, action)
    end
  end
end
