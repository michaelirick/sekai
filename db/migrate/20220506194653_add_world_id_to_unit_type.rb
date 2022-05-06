class AddWorldIdToUnitType < ActiveRecord::Migration[6.1]
  def change
    add_column :unit_types, :world_id, :integer
  end
end
