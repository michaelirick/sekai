class AddGeometryToTerrain < ActiveRecord::Migration[6.1]
  def change
    add_column :terrains, :geometry, :geometry_collection
  end
end
