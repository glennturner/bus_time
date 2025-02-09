# frozen_string_literal: true

require "test_helper"

class BusTime::ApiTest < BusTime::BusTimeTest
  test "if retrieves routes and directions and stops" do
    routes = @bus_time.fetch_routes_and_directions_and_stops
    assert_not_empty routes

    routes.each do |route|
      assert_include expected_route_ids, route.id
      assert_not_empty route.directions
      assert_equal expected_directions.map { |d| d["dir"] }, route.directions
      assert_not_empty route.stops
    end
  end
end
