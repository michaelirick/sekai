class Biome < ApplicationRecord
  include ScopedToWorld
  include UniqueColor
  include Geometriable

  def has_unique_color?
    world.biomes.where.not(id: id).where(color: color).count == 0
  end

  def new_geometry_query
    %(
      SELECT st_asgeojson(st_union(a.new_geometry)) AS new_geometry
from
      (SELECT (st_union(geometry)) AS new_geometry
      FROM geo_layers
      WHERE biome_id=#{id} AND world_id=#{world.id}) a
                                               )
  end
end
