class CreateBuildings < ActiveRecord::Migration[6.1]
  def change
    create_table :buildings do |t|
      t.string :name
      t.integer :building_type_id
      t.string :flags
      t.integer :location_id
      t.string :location_type
      t.integer :owner_id
      t.string :owner_type
      t.string :owner_name
      t.date :completion_date
      t.integer :world_id

      t.timestamps
    end
  end
end
