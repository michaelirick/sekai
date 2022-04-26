class RemoveBiomeAndTerrainFromGeoLayer < ActiveRecord::Migration[6.1]
  def change
    remove_column :geo_layers, :biome, :string
    remove_column :geo_layers, :terrain, :string
  end
end
