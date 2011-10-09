class Onebusaway::Base
  def self.from_xml(xml_or_data)
    xml_or_data = REXML::Document.new(xml_or_data).root if xml_or_data.is_a?(String)
    self.parse(xml_or_data)
  end

  def self.parse(data)
    raise NotImplementedError
  end
end

