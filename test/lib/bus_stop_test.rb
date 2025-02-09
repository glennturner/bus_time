# frozen_string_literal: true

require "test_helper"

class BusTime::BusStopTest < BusTime::BusTimeTest
  test "if has nearby stops" do
    nearby_coords = [41.9809728, -87.6650963]

    assert stop.nearby?(nearby_coords[0], nearby_coords[1])
    assert !stop.nearby?(nearby_coords[0], nearby_coords[1] * 2)
  end

  private

  def stop
    BusTime::BusStop.new("1234", "Clark & Little Bad Wolf",
                         coords: [41.9833784, -87.6689953],
                         direction: "Southbound")
  end
end
