class CreateRegions < ActiveRecord::Migration[6.1]
  def change
    create_table :regions do |t|
      t.string :name
      t.integer :subcontinent_id

      t.timestamps
    end
  end
end
