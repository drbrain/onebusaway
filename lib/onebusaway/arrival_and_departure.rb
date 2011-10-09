class Onebusaway::ArrivalAndDeparture < Onebusaway::Base
  attr_accessor :routeId, :routeShortName, :tripId, :tripHeadsign, :stopId, :predictedArrivalTime, :scheduledArrivalTime, :predictedDepartureTime, :scheduledDepartureTime, :status
  def self.parse(data)
    arrival = self.new
    [:routeId, :routeShortName, :tripId, :tripHeadsign, :stopId, :predictedArrivalTime, :scheduledArrivalTime, :predictedDepartureTime, :scheduledDepartureTime, :status].each do |attr|
      value = data.elements[attr.to_s]
      arrival.send("#{attr}=", value.text) if value
    end
    arrival
  end

  def minutes_from_now
    @minutes_from_now ||= begin
      at = predictedArrivalTime.to_i
      if at == 0
        # no predicted time, use scheduled
        (scheduledArrivalTime.to_i/1000 - Time.now.to_i) / 60
      else
        (predictedArrivalTime.to_i/1000 - Time.now.to_i) / 60
      end
    end
    @minutes_from_now
  end
end

