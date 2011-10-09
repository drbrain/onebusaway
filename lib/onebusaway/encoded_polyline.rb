class Onebusaway::EncodedPolyline < Onebusaway::Base
  attr_accessor :length
  attr_accessor :levels
  attr_accessor :points

  def initialize json
    @length = json['length'].to_i
    @levels = json['levels']
    @points = json['points']
  end

end

