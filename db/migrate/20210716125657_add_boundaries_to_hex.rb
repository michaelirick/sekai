class AddBoundariesToHex < ActiveRecord::Migration[6.1]
  def change
    add_column :hexes, :boundaries, :geometry_collection
  end
end
