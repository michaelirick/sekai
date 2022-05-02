class AddBiomeAndTerrainToGeoLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :geo_layers, :biome, :string
    add_column :geo_layers, :terrain, :string
  end
end
