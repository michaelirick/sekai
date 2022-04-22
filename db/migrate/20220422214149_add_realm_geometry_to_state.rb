class AddRealmGeometryToState < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :realm_geometry, :geometry_collection
  end
end
