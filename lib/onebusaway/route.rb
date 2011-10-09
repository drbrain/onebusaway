class Onebusaway::Route < Onebusaway::Base
  attr_accessor :id, :shortName, :longName, :description, :type, :url, :agency
  def self.parse(data)
    route = self.new
    [:id, :shortName, :longName, :description, :type, :url].each do |attr|
      value = data.elements[attr.to_s]
      route.send("#{attr}=", value.text) if value
    end
    route.agency = Agency.parse(data.elements["agency"])
    route
  end
end

