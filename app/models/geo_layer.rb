class GeoLayer < ApplicationRecord
  belongs_to :world
  belongs_to :parent, polymorphic: true
  belongs_to :owner, polymorphic: true, optional: true
  has_many :children, class_name: 'GeoLayer', as: :parent

  HEX_RADIUS = 6.0469

  def self.add_geo_layer_level(layer)
    @geo_layer_levels = [] unless @geo_layer_levels
    @geo_layer_levels << layer
    scope :"#{layer.to_s.pluralize}_for", -> (world) { where(type: layer.to_s.classify, world: world) }
  end

  def self.geo_layer_levels
    @geo_layer_levels
  end

  def self.for(world)
    @geo_layer_levels.map do |layer|
      { layer.to_s.pluralize.to_sym => send(:"#{layer.to_s.pluralize}_for", world) }
    end.reduce :merge
  end

  def factory
    world.factory
  end

  def all_children_ids
    (children.map(&:id) + children.map(&:all_children_ids)).flatten.uniq
  end

  def self.reset_geometry_for!(world, options={})
    classes = [Hex, Province, Area, Region, Subcontinent, Continent]
    classes -= options[:except] || []
    classes.each do |c|
      puts "Resetting #{c}..." if ENV['DEBUG'] == '1'
      c.where(world: world).each &:reset_geometry!
    end
  end

  # odd-q hexes
  def self.point_to_hex(x, y)
    q = ((2.0/3 * x) / HEX_RADIUS).round
    r = ((-1.0/3 * x + Math.sqrt(3)/3 * y) / HEX_RADIUS).round
    y = r + (q - (q & 1))/2
    [q, y]
  end

  # odd-q hexes
  def self.hex_to_point(x, y)
    radius = HEX_RADIUS
    nx = radius * x * 3.0/2
    ny = radius * Math.sqrt(3) * (y + 0.5 * (x & 1))
    [nx, ny]
  end

  def self.draw_hex(center)
    radius = HEX_RADIUS
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

  def self.hex_geometry(points, factory)
    points = points.map do |p|
      px, py = p
      factory.point(px, py)
    end

    ring = factory.linear_ring points
    polygon = factory.polygon(ring)
    factory.collection([polygon])
  end

  def reset_hex!
    self.geometry = GeoLayer.hex_geometry GeoLayer.draw_hex(GeoLayer.hex_to_point(x, y)), factory
    save!
  end

  def reset_geometry!
    if type == 'Hex'
      reset_hex!
      return
    end
    new_geometry = GeoLayer.connection.execute(%(
      SELECT st_asgeojson(st_union(a.new_geometry)) AS new_geometry
from
      (SELECT st_asgeojson(st_union(geometry)) AS new_geometry
      FROM geo_layers
      WHERE parent_id=#{id} AND parent_type='GeoLayer') a
                                               )).map(&:to_h).first['new_geometry']
#     new_geometry = GeoLayer.connection.execute(%(
#       SELECT st_asgeojson(st_union(st_snaptogrid(geometry, 0.0001))) AS new_geometry
#       FROM geo_layers
#       WHERE parent_id=#{id} AND parent_type='GeoLayer'
#                                                )).map(&:to_h).first['new_geometry']

    polygons = children.pluck(:geometry).compact.map(&:to_a).flatten

    new_geometry = RGeo::GeoJSON.decode new_geometry
    self.geometry = factory.collection [new_geometry].compact
    self.save!
  rescue => e
    puts "#{type} #{id} #{title} failed to reset geometry:"
    puts e.full_message
  end

  def update_geometry!(points)
    puts "points: #{points.inspect}"
    points = points.map do |x, y|
      factory.point(x, y)
    end

    self.geometry = factory.collection [factory.polygon(factory.linear_ring(points))]
    save!
  end

  scope :for_world, ->(w) { where world: w }

  add_geo_layer_level :continent
  add_geo_layer_level :subcontinent
  add_geo_layer_level :region
  add_geo_layer_level :area
  add_geo_layer_level :province
  # Hex is too much
  # add_geo_layer_level :hex
end
