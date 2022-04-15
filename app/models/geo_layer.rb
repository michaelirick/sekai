class GeoLayer < ApplicationRecord
  belongs_to :world
  belongs_to :parent, polymorphic: true
  belongs_to :owner, polymorphic: true, optional: true
  has_many :children, class_name: 'GeoLayer', as: :parent

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

  def reset_geometry!
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
