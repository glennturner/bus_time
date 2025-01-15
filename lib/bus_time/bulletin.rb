# frozen_string_literal: true

# Service bulletins, including reroutes and stop closures
class BusTime::Bulletin
  attr_reader :name, :subject, :url, :updated_at

  def initialize(name, subject, affected, updated_at, **opts)
    @name = name
    @subject = subject
    @affected = affected
    @updated_at = updated_at
    @url = opts[:url]
  end
end
