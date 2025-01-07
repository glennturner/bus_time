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

# Get current service time
bus_service.get_time # YYYYMMDD HH:MM:SS

# Get all routes
routes = bus_service.get_routes # [<BusRoute id: <String>, name: <String>, directions: [], stops: []>,... ]

# Get a single route
route = bus_service.get_route(route_id) # <BusRoute { id: <String>, name: <String>, directions: [<String>,...], stops: [<BusStop>,...]}

# Get a single stop
stop = bus_service.get_stop(stop_id) # <BusStop { }
```

`API_URL` defaults to "https://ctabustracker.com/bustime/api/v2"

Consult the service provider's developer documentation for non-CTA service URLs.

## Limitations

`bus_time` is focused on retrieving stop predictions. Consequently, this gem is currently...

- Not optimized for _BusTime v3_ dynamic features

- Does not support vehicle requests

- Does not support pattern requests

- Does have `Real-Time Passenger` support

- Does not have locale support

## To-Do

- Deprecate API_URL with known APIs and API versions

## Author

[G. Turner](mailto:contact@iamgturner.com)
