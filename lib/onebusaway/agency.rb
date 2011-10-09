class Onebusaway::Agency < Onebusaway::Object

  attr_accessor :id
  attr_accessor :lang
  attr_accessor :name
  attr_accessor :phone
  attr_accessor :timezone
  attr_accessor :url

  def initialize json
    @id       = json['id'].to_i
    @lang     = json['lang']
    @name     = json['name']
    @phone    = json['phone']
    @timezone = json['timezone']
    @url      = json['url']
  end

end

