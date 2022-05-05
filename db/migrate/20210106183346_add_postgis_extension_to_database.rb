class AddPostgisExtensionToDatabase < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'postgis'
    enable_extension 'postgis_raster'
  end
end
