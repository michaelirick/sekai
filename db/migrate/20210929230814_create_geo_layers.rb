class CreateGeoLayers < ActiveRecord::Migration[6.1]
  def change
    create_table :geo_layers do |t|
      t.string :title
      t.integer :parent_id
      t.string :parent_type
      t.integer :x
      t.integer :y
      t.integer :world_id
      t.string :type

      t.timestamps
    end
  end
end
