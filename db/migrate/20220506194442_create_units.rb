class CreateUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :units do |t|
      t.string :title
      t.integer :state_id
      t.integer :casualties
      t.integer :unit_type_id
      t.integer :force_id

      t.timestamps
    end
  end
end
