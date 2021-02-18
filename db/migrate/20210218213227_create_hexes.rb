class CreateHexes < ActiveRecord::Migration[6.1]
  def change
    create_table :hexes do |t|
      t.integer :world_id
      t.integer :x
      t.integer :y
      t.integer :owner_id
      t.integer :province_id
      t.string :terrain_type

      t.timestamps
    end
  end
end
