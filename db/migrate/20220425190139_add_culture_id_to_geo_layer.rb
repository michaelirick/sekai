class AddCultureIdToGeoLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :geo_layers, :culture_id, :integer
  end
end
