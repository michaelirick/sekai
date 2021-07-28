class AddBoundariesToArea < ActiveRecord::Migration[6.1]
  def change
    add_column :areas, :boundaries, :geometry_collection
  end
end
