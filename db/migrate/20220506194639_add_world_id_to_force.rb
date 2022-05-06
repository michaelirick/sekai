class AddWorldIdToForce < ActiveRecord::Migration[6.1]
  def change
    add_column :forces, :world_id, :integer
  end
end
