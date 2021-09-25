class CreateWorldDates < ActiveRecord::Migration[6.1]
  def change
    create_table :world_dates do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :age_id
      t.index [:age_id, :year, :month, :day], unique: true

      t.timestamps
    end
  end
end
