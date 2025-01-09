# frozen_string_literal: true

# Service bus stop prediction handling, including prediction retrieval
# via `BusTime::Api`
class BusTime::Prediction
  attr_reader :time, :prediction_type, :delayed, :generated_at,
              :stop_id, :stop_name, :direction

  def initialize(route_id, direction, stop_id, arrival_minutes, **opts)
    @route_id = route_id
    @stop_id = stop_id
    @direction = direction
    @arrival_minutes = arrival_minutes

    @stop_name = opts[:stop_name]

    @arrives_at = opts[:arrives_at]
    @prediction_type = opts[:prediction_type] || "arrival"
    @delayed = opts[:delayed] || false

    @generated_at = opts[:generated_at] || DateTime.now
  end

  def delayed?
    @delayed
  end
end
