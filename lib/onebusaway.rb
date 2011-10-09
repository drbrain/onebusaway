require 'open-uri'
require 'json'

class Onebusaway

  attr_accessor :api_base

  def initialize api_key
    @api_key = api_key
    @api_base = 'http://api.onebusaway.org/api/where/'
  end

  def stop_by_id stop_id
    result = request 'stop', id: stop_id

    Stop.new result
  end

  def route_by_id route_id
    result = request 'route', id: route_id

    Route.new result
  end

  def stops_for_location lat, lon
    doc = request 'stops-for-location', lat: lat, lon: lon

    stops = []

    doc.elements.each 'stops/stop' do |stop_el|
      stops << Stop.from_xml(stop_el)
    end

    stops
  end

  def routes_for_location lat, lon
    doc = request 'routes-for-location', lat: lat, lon: lon

    routes = []
    doc.elements.each 'routes/route' do |route_el|
      routes << Route.from_xml(route_el)
    end
    routes
  end

  def stops_for_route route_id
    doc = request 'stops-for-route', id: route_id

    stops = []
    doc.elements.each 'stops/stop' do |stop_el|
      stops << Stop.from_xml(stop_el)
    end
    stops
  end

  def arrivals_and_departures_for_stop stop_id
    result = request 'arrivals-and-departures-for-stop', id: stop_id

    result['arrivalsAndDepartures'].map do |arr_dep|
      ArrivalAndDeparture.new arr_dep
    end
  end

  private

  def api_url call, options = {}
    url = @api_base + call
    id = options.delete :id
    if id
      url += '/' + id
    end
    url += '.json?'
    options[:key] = @api_key
    url += options.to_a.map{|pair| "#{pair[0]}=#{pair[1]}"}.join("&")
    url
  end

  def request call, url_options
    url = api_url call, url_options

    json = open(url).read

    result = JSON.parse json
    code = result['code'].to_s
    text = result['text']

    raise "Request failed (#{code}): #{text}" unless code.start_with? '2'

    result['data']
  end

  autoload :Agency,              'onebusaway/agency'
  autoload :ArrivalAndDeparture, 'onebusaway/arrival_and_departure'
  autoload :Base,                'onebusaway/base'
  autoload :EncodedPolyline,     'onebusaway/encoded_polyline'
  autoload :Route,               'onebusaway/route'
  autoload :Stop,                'onebusaway/stop'

end

