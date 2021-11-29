# frozen_string_literal: true

require 'http'
require 'json'

module API
  module Requests
    class << self
      def get(url, params = {})
        resp = HTTP.timeout(1).get(url, params: params)
        JSON.parse(resp)
      end
    end
  end
end

module GoogleMaps
  module Geocode
    BASE_URL = 'https://maps.googleapis.com/maps/api/geocode'

    def address_to_coordinates(address, format: 'json')
      API::Requests.get(BASE_URL + "/#{format}", { address: address, key: @api_key })
    end

    def coordinates_to_address(coordinates, format: 'json')
      API::Requests.get(BASE_URL + "/#{format}", { latlng: coordinates, key: @api_key })
    end
  end
end

module GoogleMaps
  module Directions
    BASE_URL = 'https://maps.googleapis.com/maps/api/directions'

    def get_directions(origin, destination, format: 'json')
      API::Requests.get(BASE_URL + "/#{format}",
                        { origin: "place_id:#{origin}", destination: "place_id:#{destination}", key: @api_key })
    end
  end
end

module GoogleMaps
  class Client
    include GoogleMaps::Geocode
    include GoogleMaps::Directions

    def initialize(api_key = nil)
      if api_key.nil?
        raise 'MAPS_API_KEY environment variable is not defined' unless ENV['MAPS_API_KEY']

        @api_key = ENV['MAPS_API_KEY']
      else
        @api_key = api_key
      end
    end
  end
end

def to_query_string(string)
  string.gsub(/\s+/, '+')
end