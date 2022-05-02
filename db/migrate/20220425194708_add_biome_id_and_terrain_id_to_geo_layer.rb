class AddBiomeIdAndTerrainIdToGeoLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :geo_layers, :biome_id, :integer
    add_column :geo_layers, :terrain_id, :integer
  end
end
