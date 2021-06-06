class CreateMapLayers < ActiveRecord::Migration[6.1]
  def change
    create_table :map_layers do |t|
      t.string :title
      t.integer :world_id

      t.timestamps
    end
  end
end
