# frozen_string_literal: true

require File.expand_path("lib/bus_time/version", __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ["G Turner"]
  gem.email         = ["contact@iamgturner.com"]
  gem.summary       = 'A BusTime API wrapper to retrieve bus routing and prediction info from transit authorities.'
  gem.description   = <<-DESC
                        A BusTime API wrapper to retrieve bus routing and prediction info from transit authorities such as the Chicago Transit Authority (CTA).
  DESC
  gem.homepage      = "https://github.com/glennturner/bus_time"
  gem.license       = "MIT"

  gem.files         = Dir['lib/**/*.rb']
  gem.name          = "bus_time"
  gem.require_paths = ["lib"]
  gem.version       = BusTime::VERSION

  gem.required_ruby_version = ">= 2.4"

  gem.add_dependency "geocoder", "~> 1.8"
  gem.add_dependency "zeitwerk", "~> 2.7"

  # Development/test dependencies
  gem.add_development_dependency "m", "~> 1.6"
  gem.add_development_dependency "rake", "~> 13.2"
  gem.add_development_dependency "rubocop", "~> 1.6"
  gem.add_development_dependency "test-unit", "~> 3.6"
  gem.add_development_dependency "webmock", "~> 3.24"
end
