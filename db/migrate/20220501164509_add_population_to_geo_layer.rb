class AddPopulationToGeoLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :geo_layers, :population, :integer
  end
end
