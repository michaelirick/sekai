class CreateStates < ActiveRecord::Migration[6.1]
  def change
    create_table :states do |t|
      t.string :name
      t.string :adjective
      t.integer :world_id
      t.string :primary_color
      t.string :secondary_color

      t.timestamps
    end
  end
end
