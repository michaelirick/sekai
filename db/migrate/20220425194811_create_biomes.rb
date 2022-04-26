class CreateBiomes < ActiveRecord::Migration[6.1]
  def change
    create_table :biomes do |t|
      t.string :title
      t.integer :low_moisture
      t.integer :high_moisture
      t.integer :low_tempurature
      t.integer :high_tempurature
      t.string :color

      t.timestamps
    end
  end
end
