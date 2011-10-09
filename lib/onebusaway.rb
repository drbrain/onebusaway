require 'open-uri'
require 'rexml/document'

class Onebusaway

  attr_accessor :api_base

  def initialize api_key
    @api_key = api_key
    @api_base = 'http://api.onebusaway.org/api/where/'
  end

  def stop_by_id stop_id
    xml = request 'stop', id: stop_id

    stop = Stop.from_xml xml
  end

  def route_by_id route_id
    xml = request 'route', id: route_id
    route = Route.from_xml xml
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
    doc = request 'arrivals-and-departures-for-stop', id: stop_id

    arrivals = []
    doc.elements.each 'arrivalsAndDepartures/arrivalAndDeparture' do |arrival_el|
      arrivals << ArrivalAndDeparture.from_xml(arrival_el)
    end
    arrivals
  end

  private

  def api_url(call, options = {})
    url = @api_base + call
    id = options.delete(:id)
    if id
      url += '/' + id
    end
    url += '.xml?'
    options[:key] = @api_key
    url += options.to_a.map{|pair| "#{pair[0]}=#{pair[1]}"}.join("&")
    url
  end

  def request(call, url_options)
    url = api_url(call, url_options)

    doc = REXML::Document.new(open(url))
    root = doc.root
    status_code = root.elements['code'].text
    status_text = root.elements['text'].text

    # failed status
    unless /2\d{2}/.match(status_code)
      raise "Request failed (#{status_code}): #{status_text}"
    end

    return root.elements['data']
  end

  autoload :Agency,              'onebusaway/agency'
  autoload :ArrivalAndDeparture, 'onebusaway/arrival_and_departure'
  autoload :Base,                'onebusaway/base'
  autoload :EncodedPolyline,     'onebusaway/encoded_polyline'
  autoload :Route,               'onebusaway/route'
  autoload :Stop,                'onebusaway/stop'

end

