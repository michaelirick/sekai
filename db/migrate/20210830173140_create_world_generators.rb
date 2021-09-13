class CreateWorldGenerators < ActiveRecord::Migration[6.1]
  def change
    create_table :world_generators do |t|
      t.string :title
      t.integer :plates
      t.integer :width
      t.integer :height
      t.integer :seed
      t.integer :world_id

      t.timestamps
    end
  end
end
