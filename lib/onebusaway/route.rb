class Onebusaway::Route < Onebusaway::Object

  attr_accessor :agency
  attr_accessor :description
  attr_accessor :id
  attr_accessor :long_name
  attr_accessor :short_name
  attr_accessor :type
  attr_accessor :url

  def initialize json
    @id          = convert_id json['id']
    @agency      = json['agency'].to_i
    @description = json['description']
    @long_name   = json['longName']
    @short_name  = json['shortName']
    @type        = json['type']
    @url         = json['url']
  end

end

