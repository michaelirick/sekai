class Worlds::Show < ApplicationRepresentor
  def attributes
    %i[id name resolution_x resolution_y circumference hex_radius]
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
    return {}
    GeoLayer.for(self.__getobj__).map do |key, values|
      values = values.map do |v|
        {
          name: v.title,
          points: RGeo::GeoJSON.encode(v.geometry),
          layer: key
        }
      end
      { key => values }
    end.reduce :merge
  end

  def extra_attributes
    {
      map_layers: map_layers_attributes,
      geo_layers: geo_layers_attributes
    }
  end
end
