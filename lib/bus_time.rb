# BusTimings

# Interact with BusTime APIs to retrieve bus routing and prediction info from transit authorities such as the Chicago Transit Authority (CTA).
#
# @author Glenn Turner
module BusTime
  class << self
    attr_accessor :api
  end

  def self.connection(api_key, api_url = nil)
    @api ||= BusTime::Api.new(api_key, api_url)
  end
end

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup
