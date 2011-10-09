class Onebusaway::Stop < Onebusaway::Base
  attr_accessor :id, :lat, :lon, :direction, :name, :code, :locationType, :routes
  def self.parse(data)
    stop = self.new
    [:id, :lat, :lon, :direction, :name, :code, :locationType].each do |attr|
      value = data.elements[attr.to_s]
      stop.send("#{attr}=", value.text) if value
    end
    stop.routes ||= []
    data.elements.each("routes/route") do |route_el|
      stop.routes << Route.parse(route_el)
    end
    stop
  end
end

