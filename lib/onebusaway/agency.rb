class Onebusaway::Agency < Onebusaway::Base
  attr_accessor :id, :name, :url, :timezone, :lang, :phone
  def self.parse(data)
    agency = self.new
    [:id, :name, :url, :timezone, :lang, :phone].each do |attr|
      value = data.elements[attr.to_s]
      agency.send("#{attr}=", value.text) if value
    end
    agency
  end
end

