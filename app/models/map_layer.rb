class MapLayer < ApplicationRecord
  resourcify
  belongs_to :world

  has_one_attached :image
  scope :for_world, -> (w) { where(world_id: w) }

  def insert_raster(path)
    t = `raster2pgsql #{path}`

    # t.gsub!(/Processing .*VALUES (')/, '')
    t = t.scan(/'([^']*)'/).first.first
    ''.gsub("'", '')
    # binding.pry
    self.raster = t
    save
  end

  def polygons
    # result = MapLayer.connection.execute %(select * from (select st_asgeojson(ST_DumpAsPolygons(raster)) from map_layers where id=#{id}) a)
    result = MapLayer.connection.execute %(select ST_DumpValues(raster) from map_layers where id=#{id})
  end
end
