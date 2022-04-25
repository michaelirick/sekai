class CreateCultures < ActiveRecord::Migration[6.1]
  def change
    create_table :cultures do |t|
      t.string :title
      t.string :color
      t.integer :world_id

      t.timestamps
    end
  end
end
