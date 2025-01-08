module BusTime
  class Prediction
    attr_reader :time, :prediction_type, :delay, :generated_at

    def initialize(arrives_at, delayed: false, generated_at: DateTime.now)
      @arrives_at = arrives_at
      @delayed = delayed
      @generated_at = generated_at
    end
  end
end
