class AddGeometryToGeoLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :geo_layers, :geometry, :multi_polygon
  end
end
