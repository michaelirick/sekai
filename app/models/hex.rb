class Hex < GeoLayer
  after_create :reset_geometry!
  validates_uniqueness_of :x, scope: %i[y world_id]

  DIRECTIONS = {
    north: [0, 1],
    south: [0, -1],
    northeast: [1, 0],
    southeast: [1, -1],
    northwest: [-1, 0],
    southwest: [-1, -1]
  }

  def farmers_count
    (population || 0) / 3
  end

  def population_capacity
    # lots * 250
    farmers_count * 30
  end

  def net_population_capacity
    population_capacity - population
  end

  DIRECTIONS.each do |dir, offset|
    define_method dir do
      ox, oy = offset
      world.geo_layers.hexes.where(type: 'Hex', x: x + ox, y: y + oy).first
    end
  end
end
# #require 'geometry'

# class Hex < ApplicationRecord
#   include GeoLayerable
#   resourcify
#   belongs_to :province
#   belongs_to :owner, class_name: 'State', optional: true
#   belongs_to :world

#   scope :for_world, -> (w) { where(world_id: w) }

#   scope :viewable_on_map_at, -> (world, x, y, zoom) do
#     return where('1=1')
#     return where('1=2') if zoom < 2
#     hexes = where(world: world)
#     range = 100
#     {x: x, y: y}.each do |c, v| # coord, value
#       [-1, 1].each do |m| # multiple
#         d = (m * range * (1.0/zoom))
#         bound = v + d
#         hexes = hexes.where(
#           "#{c} #{m.positive? ? '<' : '>'} ?",
#           bound
#         )
#       end
#     end

#     hexes
#   end

#   def to_shape
#     t = 6.9282
#     Geometry::RegularPolygon.new(sides: 6, radius: t, center: [x, y])
#   end

#   def create_rgeo(points)
#     binding.pry
#     factory = world.geo_factory
#     points = points.map do |p|
#       factory.point *p #[p.last, p.first]
#     end

#     factory.polygon(factory.linear_ring(points))
#   end

#   def create_collection(polygons)
#     world.geo_factory.collection polygons
#   end

#   def update_boundaries!(points)
#     self.boundaries = create_collection [create_rgeo(points)]
#     save!
#   end
# end
