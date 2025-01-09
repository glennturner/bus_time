# frozen_string_literal: true

# BusTimings

# Interact with BusTime APIs to retrieve bus routing and prediction info from transit authorities such as the Chicago Transit Authority (CTA).
#
# @author Glenn Turner
module BusTime
  MAX_NEARBY_DISTANCE = 0.5

  def self.connection(api_key, api_url = nil)
    @connection ||= BusTime::Api.new(api_key, api_url)
  end

  def self.nearby_distance
    @nearby_distance || MAX_NEARBY_DISTANCE
  end

  def self.nearby_distance=(distance)
    @nearby_distance = distance
  end

  def self.api
    @connection
  end
end

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup
