class World < ApplicationRecord
  include GeoLayerable
  resourcify
  has_many :states
  # has_many :contine/nts
  has_many :map_layers
  has_many :geo_layers
  # has_many :hegxes
  belongs_to :user
  has_many :settlements
  has_many :cultures
  has_many :biomes
  # add_geo_layer(
  #   name: 'World',
  #   subordinates: :continents
  # )

  HEX_RADIUS = 6.0469 # miles

  scope :for_user, -> (user) { where(user: user) }

  def factory
    @factory ||= RGeo::Cartesian.factory
    @factory
  end

  def reset_geometry!

  end

  def pixel_length
    (circumference || 1.0) / (resolution_x || 1.0)
  end

  def hex_radius
    HEX_RADIUS / pixel_length
  end

  # odd-q hexes
  def point_to_hex(x, y)
    q = ((2.0/3 * x) / hex_radius).round
    r = ((-1.0/3 * x + Math.sqrt(3)/3 * y) / hex_radius).round
    ny = r + (q - (q & 1))/2
    [q, ny]
  end

  # odd-q hexes
  def hex_to_point(x, y)
  radius = hex_radius
  nx = radius * x * 3.0/2
  ny = radius * Math.sqrt(3) * (y + 0.5 * (x & 1))
  [nx, ny]
  end

  def draw_hex(center)
    radius = hex_radius
    x, y = center
    sides = 6
    grade = 2 * Math::PI / sides
    sides.times.map do |i|
      [
        (Math.cos(grade * i) * radius) + x,
        (Math.sin(grade * i) * radius) + y
      ]
    end
  end

  def hex_geometry(points)
    points = points.map do |p|
      px, py = p
      factory.point(px, py)
    end

    geometry_from_points points
  end

  def geometry_from_points(points)
    ring = factory.linear_ring points
    polygon = factory.polygon(ring)
    factory.collection([polygon])
  end
  # GEO_LAYER_TYPES = %i[
  #   continent
  #   subcontinent
  #   region
  #   area
  #   province
  # ].freeze

  # # inverse mapping to the relation needed to group
  # %i[
  #   subcontinents
  #   regions
  #   areas
  #   provinces
  # ].each do |sub|
  #   define_method sub do
  #     geo_subordinates.map(&sub).flatten
  #   end
  # end

  # # def subcontinents
  # #   continents.map(&:subcontinents)
  # # end

  # def geo_layers
  #   GEO_LAYER_TYPES.map do |glt|
  #     {
  #       name: glt,
  #       points: send(glt.to_s.pluralize).map do |sub|
  #         {name: sub.name, points: sub.to_geojson}
  #       end
  #     }
  #   end
  # end

  # def geo_factory
  #   RGeo::Cartesian.preferred_factory()
  # end
end
