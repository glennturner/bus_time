# frozen_string_literal: true

# BusTime API interface and response handling
class BusTime::Api
  attr_accessor :api_key, :api_url

  SUPPORTED_ACTIONS = %w[
    gettime getroutes getdirections
    getstops getpredictions getservicebulletins
  ].freeze

  BASE_RESPONSE_PROP = "bustime-response"

  def initialize(api_key, api_url = nil)
    @api_key = api_key
    @api_url = api_url || "https://ctabustracker.com/bustime/api/v2"
  end

  def fetch_time
    request("gettime")["tm"]
  end

  def fetch_routes
    request("getroutes")["routes"].map do |route|
      assemble_route(route)
    end
  end

  def fetch_route(id)
    route = fetch_routes.find { |returned_route| returned_route.id == id }

    # Get route stops
    route.directions.each do |dir|
      route.stops += fetch_stops(route.id, dir)
    end

    route
  end

  def fetch_directions(route_id)
    request("getdirections", { rt: route_id })["directions"].map do |direction|
      direction["dir"]
    end
  end

  def fetch_stops(route_id, direction)
    fetch_stops_by_params(rt: route_id, dir: direction)
  end

  def fetch_predictions(stop_id)
    request("getpredictions", { stpid: stop_id })["prd"].map do |prediction|
      assemble_prediction(prediction)
    end
  end

  def fetch_bulletins
    request("getservicebulletins")["sb"].map do |bulletin|
      BusTime::Bulletin.new(
        bulletin["nm"]
      )
    end
  end

  def fetch_routes_and_directions_and_stops
    routes = fetch_routes

    routes.each do |route|
      route.directions.each do |dir|
        route.stops += fetch_stops(route.id, dir)
      end
    end

    routes
  end

  private

  def request(action, params = {})
    require "net/http"
    require "json"

    raise ArgumentError, "Invalid action: #{action}" unless SUPPORTED_ACTIONS.include?(action)

    res = Net::HTTP.get_response(
      request_uri(action, params)
    )

    case res
    when Net::HTTPSuccess
      handle_request_response(res)
    end
  end

  def request_uri(action, params = {})
    params[:key] = @api_key
    params[:format] = "json"
    params[:locale] = "en"

    uri = URI.parse("#{@api_url}/#{action}")
    uri.query = URI.encode_www_form(params)
    uri
  end

  def fetch_stops_by_params(params)
    request("getstops", params)["stops"].map do |stop|
      assemble_stop(stop, params)
    end
  end

  def handle_request_response(response)
    processed = JSON.parse(response.body)[BASE_RESPONSE_PROP]
    if processed["error"]
      raise ArgumentError, "Error: #{
        processed['error'].map { |err| err['msg'] }.join(', ')
      }"
    end

    processed
  end

  def assemble_route(route)
    BusTime::BusRoute.new(route["rt"], route["rtnm"])
  end

  def assemble_stop(stop, params = {})
    BusTime::BusStop.new(stop["stpid"], stop["stpnm"],
                         coords: [stop["lat"], stop["lon"]],
                         direction: params[:dir],
                         routes: [params[:rt]])
  end

  def assemble_prediction(prediction)
    BusTime::Prediction.new(prediction["rt"], prediction["rtdir"],
                            prediction["stpid"],
                            prediction["prdctdn"],
                            arrives_at: DateTime.parse(prediction["prdtm"]),
                            destination: prediction["des"],
                            prediction_type: prediction["typ"],
                            delayed: prediction["dly"],
                            stop_name: prediction["stpnm"],
                            vehicle_id: prediction["vid"],
                            trip_id: prediction["tatripid"],
                            generated_at: DateTime.parse(prediction["tmstmp"]))
  end
end
