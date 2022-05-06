class CreateUnitTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_types do |t|
      t.string :title
      t.integer :state_id
      t.string :unit_type
      t.string :flags
      t.integer :strength

      t.timestamps
    end
  end
end
