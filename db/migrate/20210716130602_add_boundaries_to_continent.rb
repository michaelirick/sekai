class AddBoundariesToContinent < ActiveRecord::Migration[6.1]
  def change
    add_column :continents, :boundaries, :geometry_collection
  end
end
