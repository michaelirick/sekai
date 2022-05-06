class CreateForces < ActiveRecord::Migration[6.1]
  def change
    create_table :forces do |t|
      t.string :title
      t.integer :location_id
      t.string :location_type
      t.integer :state_id

      t.timestamps
    end
  end
end
