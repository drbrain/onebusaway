class Onebusaway::Base
  attr_accessor :agency

  def convert_id id
    @agency, id = id.split('_', 2).map { |v| v.to_i }

    id
  end

  def convert_timestamp timestamp
    Time.at timestamp.to_i / 1000
  end

end

