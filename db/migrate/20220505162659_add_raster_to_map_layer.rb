class AddRasterToMapLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :map_layers, :raster, :raster
  end
end
