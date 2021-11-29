# frozen_string_literal: true

require 'spec_helper'

describe GoogleMaps::Geocode do
  include GoogleMaps::Geocode
  # Initialize stub request to make sure that request is executing
  before do
    @base_url = 'https://maps.googleapis.com/maps/api/geocode/json'
    @api_key = ENV['MAPS_API_KEY']
    @address = '390 South Road, Canaan, NH'.gsub(/\s+/, '+')

    @client = GoogleMaps::Client.new
    stub_request(:get, "#{GoogleMaps::Geocode::BASE_URL}/json")
      .with(query: { 'address' => @address, 'key' => @api_key })
      .to_return(status: 200, body: File.new('./spec/geocode_output.json'))
  end

  it '#address_to_coordinates' do
    @client.address_to_coordinates(@address)
    expect(a_request(:get, @base_url)
      .with(query: { 'address' => @address, 'key' => @api_key }))
      .to have_been_made
  end

  it 'returns the correct parameter values' do
    coords = @client.address_to_coordinates(@address)
    expect(coords['test']).to eq('me')
  end
end
