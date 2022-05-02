class AddColorToGeoLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :geo_layers, :color, :string
  end
end
