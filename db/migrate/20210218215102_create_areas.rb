class CreateAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :areas do |t|
      t.string :name
      t.integer :region_id

      t.timestamps
    end
  end
end
