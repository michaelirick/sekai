class AddBoundariesToProvince < ActiveRecord::Migration[6.1]
  def change
    add_column :provinces, :boundaries, :geometry_collection
  end
end
