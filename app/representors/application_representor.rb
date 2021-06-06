require 'delegate'

class ApplicationRepresentor < SimpleDelegator
  def attributes
    []
  end

  def attrs_with_values
    attributes.map do |attr|
      {attr => send(attr)}
    end.reduce Hash.new, :merge
  end

  def extra_attributes
    {}
  end

  def to_json
    attrs_with_values.merge(extra_attributes)
  end
end
