class AddGeometryToBiome < ActiveRecord::Migration[6.1]
  def change
    add_column :biomes, :geometry, :geometry_collection
  end
end
