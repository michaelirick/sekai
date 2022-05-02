class CreateStates < ActiveRecord::Migration[6.1]
  def change
    create_table :states do |t|
      t.string :name
      t.string :adjective
      t.integer :world_id
      t.string :primary_color
      t.string :secondary_color

      t.float :stability, default: 0
      t.float :economy, default: 0
      t.float :loyalty, default: 0
      t.float :unrest, default: 0
      t.float :money, default: 0
      t.string :government_type

      t.timestamps
    end
  end
end
