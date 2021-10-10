class Worlds::Show < ApplicationRepresentor
  def attributes
    %i[id name]
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

  def geo_layers_attributes
    geo_layers.map do |gl|
      {
        title: gl[:title],
        geometry: gl.geometry
      }
    end
  end

  def extra_attributes
    {
      map_layers: map_layers_attributes,
      geo_layers: geo_layers_attributes
    }
  end
end