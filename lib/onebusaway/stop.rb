class Onebusaway::Stop < Onebusaway::Base
  attr_accessor :code
  attr_accessor :direction
  attr_accessor :id
  attr_accessor :lat
  attr_accessor :location_type
  attr_accessor :lon
  attr_accessor :name
  attr_accessor :routes

  def initialize json
    @code          = json['code']
    @direction     = json['direction']
    @id            = convert_id json['id']
    @lat           = json['lat'].to_f
    @location_type = json['locationType']
    @lon           = json['lon'].to_f
    @name          = json['name']
    @routes        = json['routes'].map { |route| Onebusaway::Route.new route }
  end

end

