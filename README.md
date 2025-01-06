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
bus_service = BusTime.new(API_KEY, API_URL)
routes = bus_service.getRoutes # [BusRoute...]
```

`API_URL` defaults to "https://ctabustracker.com/bustime/api/v2"

Consult the developer documentation for other services' urls

## To-Do

- Deprecate API_URL with known APIs and API versions

## Author

[G. Turner](mailto:contact@iamgturner.com)
# bus_time
