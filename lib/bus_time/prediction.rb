# frozen_string_literal: true

# Service bus stop prediction handling, including prediction retrieval
# via `BusTime::Api`
class BusTime::Prediction
  attr_reader :time, :prediction_type, :delay, :generated_at

  def initialize(arrives_at, delayed: false, generated_at: DateTime.now)
    @arrives_at = arrives_at
    @delayed = delayed
    @generated_at = generated_at
  end
end
