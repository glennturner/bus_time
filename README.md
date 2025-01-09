# BusTime

A no-frills gem to handle and track bus arrival times via the BusTime API, such as the MTA and CTA!

Modeled after my bus-timings [JS library](https://github.com/glenn_turner/bus-timings) to do the same.

## Requirements

BusTime requires an API key from your transit authority.

If you want to utilize Chicago Transit Authority bus times, you can request an API key via:

https://www.transitchicago.com/developers/bustracker/


## Installation

`gem install bus-timings`

## Usage

```
# Initialize
bus_service = BusTime.connection(API_KEY, API_URL?)

# General use

# Get all routes
routes = bus_service.fetch_routes # [<BusRoute id: <String>, name: <String>, directions: [], stops: []>,...]

# Get route directions
route.directions # [<String>,...]

# Get route stops
route.stops  # [<BusStop { id: <String>, name: <String>, lat: <Float>, lon: <Float>, direction: <String>, routes: <Array[<String>,...],...] }

# Get stop predictions
route.stops.first.predictions # [<Prediction { }]

# API interface, if necessary

# Get current service time
bus_service.fetch_time # YYYYMMDD HH:MM:SS

# Get a single route
route = bus_service.fetch_route(route_id)

# Get a single stop
stop = bus_service.fetch_stop(stop_id)

# Get predictions for a stop
predictions = bus_service.fetch_predictions(stop_id)

# Get nearby stops for a route
# (Nearby stops default to 0.5 miles)
stops = bus_service.route.nearby_stops

# Change nearby mile radius:
bus_service.nearby_distance = 2
```

`API_URL` defaults to "https://ctabustracker.com/bustime/api/v2"

Consult the service provider's developer documentation for non-CTA service URLs.

## Limitations

`bus_time` is focused on retrieving stop predictions. Consequently, this gem currently does not support the following:

- `BusTime v3` dynamic features

- Vehicle requests

- Pattern requests

- `Real-Time Passenger` handling

- Locale language support

## To-Do

- Complete service bulletin support

- Deprecate API_URL with known APIs and API versions

## Author

[G. Turner](mailto:contact@iamgturner.com)
