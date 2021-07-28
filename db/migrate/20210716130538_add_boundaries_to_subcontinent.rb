class AddBoundariesToSubcontinent < ActiveRecord::Migration[6.1]
  def change
    add_column :subcontinents, :boundaries, :geometry_collection
  end
end
