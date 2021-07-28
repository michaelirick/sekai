class AddCachedPointsToProvince < ActiveRecord::Migration[6.1]
  def change
    add_column :provinces, :cached_points, :json
  end
end
