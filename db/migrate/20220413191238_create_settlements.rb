class CreateSettlements < ActiveRecord::Migration[6.1]
  def change
    create_table :settlements do |t|
      t.string :name
      t.integer :hex_id
      t.integer :owner_id
      t.integer :world_id
      t.integer :population
      t.string :government_type

      t.timestamps
    end
  end
end
