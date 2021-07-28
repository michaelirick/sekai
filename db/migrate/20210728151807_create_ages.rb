class CreateAges < ActiveRecord::Migration[6.1]
  def change
    create_table :ages do |t|
      t.integer :preceding_age_id
      t.integer :world_id
      t.string :title
      t.string :abbreviation

      t.timestamps
    end
  end
end
