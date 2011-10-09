class Onebusaway::ArrivalAndDeparture < Onebusaway::Object

  attr_accessor :predicted_arrival_time
  attr_accessor :predicted_departure_time
  attr_accessor :route_id
  attr_accessor :route_short_name
  attr_accessor :scheduled_arrival_time
  attr_accessor :scheduled_departure_time
  attr_accessor :status
  attr_accessor :stop_id
  attr_accessor :trip_headsign
  attr_accessor :trip_id

  def initialize json
    @predicted_arrival_time   = convert_timestamp json['predictedArrivalTime']
    @predicted_departure_time = convert_timestamp json['predictedDepartureTime']
    @route_id                 = convert_id json['routeId']
    @route_short_name         = json['routeShortName']
    @scheduled_arrival_time   = convert_timestamp json['scheduledArrivalTime']
    @scheduled_departure_time = convert_timestamp json['scheduledDepartureTime']
    @status                   = json['status']
    @stop_id                  = convert_id json['stopId']
    @trip_headsign            = json['tripHeadsign']
    @trip_id                  = convert_id json['tripId']
  end

  def minutes_from_now
    at = @predicted_arrival_time

    if at.to_i == 0 then
      # no predicted time, use scheduled
      (@scheduled_arrival_time - Time.now) / 60
    else
      (@predicted_arrival_time - Time.now) / 60
    end.round
  end

end

