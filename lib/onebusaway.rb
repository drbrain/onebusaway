require 'open-uri'
require 'json'

class Onebusaway

  attr_reader :api_base

  def initialize api_key
    @api_key  = api_key
    @api_base = URI 'http://api.onebusaway.org/api/where/'
  end

  def make_id agency_id, sub_id
    "#{agency_id}_#{sub_id}"
  end

  def api_base= url
    @api_base = URI url
  end

  def stop_by_id agency_id, stop_id
    result = request 'stop', id: make_id(agency_id, stop_id)

    Stop.new result
  end

  def route_by_id agency_id, route_id
    result = request 'route', id: make_id(agency_id, route_id)

    Route.new result
  end

  def stops_for_location lat, lon
    result = request 'stops-for-location', lat: lat, lon: lon

    result['stops'].map do |stop|
      Stop.new stop
    end
  end

  def routes_for_location lat, lon
    result = request 'routes-for-location', lat: lat, lon: lon

    result['routes'].map do |route|
      Route.new route
    end
  end

  def stops_for_route agency_id, route_id
    result = request 'stops-for-route', id: make_id(agency_id, route_id)

    result['stops'].map do |stop|
      Stop.new stop
    end
  end

  def arrivals_and_departures_for_stop agency_id, stop_id
    result = request 'arrivals-and-departures-for-stop',
                     id: make_id(agency_id, stop_id)

    result['arrivalsAndDepartures'].map do |arr_dep|
      ArrivalAndDeparture.new arr_dep
    end
  end

  private

  def api_url method, options = {}
    options[:key] = @api_key

    id = options.delete :id

    method = [method, id].compact.join '/'
    method << '.json'

    url = @api_base + method

    url.query = options.to_a.map{|pair| "#{pair[0]}=#{pair[1]}"}.join("&")
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
  autoload :EncodedPolyline,     'onebusaway/encoded_polyline'
  autoload :Object,              'onebusaway/object'
  autoload :Route,               'onebusaway/route'
  autoload :Stop,                'onebusaway/stop'

end

