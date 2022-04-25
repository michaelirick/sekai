class AddGeometryToCulture < ActiveRecord::Migration[6.1]
  def change
    add_column :cultures, :geometry, :geometry_collection
  end
end
