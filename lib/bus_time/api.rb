module BusTime
  class Api
    attr_accessor :api_key, :api_url

    SUPPORTED_ACTIONS = %w[
      gettime getroutes getvehicles getpatterns
      getpredictions getservicebulletins getdirections
      getstops
    ]

    BASE_RESPONSE_PROP = "bustime-response"

    def initialize(api_key, api_url = nil)
      @api_key = api_key
      @api_url = api_url || "https://ctabustracker.com/bustime/api/v2"
    end

    def get_time
      request("gettime")["tm"]
    end

    def get_routes
      request("getroutes")["routes"].map do |route|
        BusTime::BusRoute.new(route["rt"], route["rtnm"])
      end
    end

    def get_route(id)
      route = get_routes.find { |route| id == id }

      # Get route stops
      route.directions.each do |dir|
        route.stops += get_stops(route.id, dir)
      end

      route
    end

    def get_directions(route_id)
      request("getdirections",
        { rt: route_id }
      )["directions"].map { |direction| direction["dir"] }
    end

    def get_stops(route_id, direction)
      get_stops_by_params(rt: route_id, dir: direction)
    end

    def get_predictions(stop_id)
      request("getpredictions",
        { stpid: stop_id }
      )["prd"].map do |prediction|
        BusTime::BusPrediction.new(
        )
      end
    end

    private

    def request(action, params = {})
      require "net/http"
      require "json"

      raise ArgumentError, "Invalid action: #{action}" if !SUPPORTED_ACTIONS.include?(action)
      res = Net::HTTP.get_response(
        request_uri(action, params)
      )

      case res
      when Net::HTTPSuccess then
        handle_request_response(res)
      end
    end

    def request_uri(action, params = {})
      params[:key] = @api_key
      params[:format] = "json"
      params[:locale] = "en"

      uri = URI.parse(@api_url + "/" + action)
      uri.query = URI.encode_www_form(params)
      uri
    end

    def get_stops_by_params(params)
      request("getstops", params)["stops"].map do |stop|
        BusTime::BusStop.new(
          stop["stpid"], stop["stpnm"],
          coords: [ stop["lat"], stop["lon"] ],
          direction: params[:dir],
          routes: [ params[:rt] ]
        )
      end
    end

    def handle_request_response(response)
      processed = JSON.parse(response.body)[BASE_RESPONSE_PROP]

      if processed["error"]
        raise ArgumentError, "Error: #{
          processed["error"].map { |err| err["msg"] }.join(", ")
        }"
      end

      processed
    end
  end
end
