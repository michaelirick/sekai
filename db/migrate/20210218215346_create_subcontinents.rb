class CreateSubcontinents < ActiveRecord::Migration[6.1]
  def change
    create_table :subcontinents do |t|
      t.string :name
      t.integer :continent_id

      t.timestamps
    end
  end
end
