class AddGeometryToState < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :geometry, :geometry_collection
  end
end
