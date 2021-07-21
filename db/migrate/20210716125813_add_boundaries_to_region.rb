class AddBoundariesToRegion < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :boundaries, :geometry_collection
  end
end
