class AddGeometryToGeoLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :geo_layers, :geometry, :geometry_collection
  end
end
