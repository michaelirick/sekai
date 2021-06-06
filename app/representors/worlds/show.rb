class Worlds::Show < ApplicationRepresentor
  def attributes
    %i[name]
  end

  def map_layers_attributes
    map_layers.map do |ml|
      {
        id: ml.id,
        title: ml.title,
        url: ml.image.try(:url),
        metadata: ml.image.metadata
      }
    end
  end

  def extra_attributes
    {
      map_layers: map_layers_attributes
    }
  end
end