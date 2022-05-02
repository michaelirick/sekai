class AddWorldIdToBiome < ActiveRecord::Migration[6.1]
  def change
    add_column :biomes, :world_id, :integer
  end
end
