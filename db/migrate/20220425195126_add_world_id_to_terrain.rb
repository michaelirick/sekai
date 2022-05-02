class AddWorldIdToTerrain < ActiveRecord::Migration[6.1]
  def change
    add_column :terrains, :world_id, :integer
  end
end
