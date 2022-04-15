class GeoLayer < ApplicationRecord
  belongs_to :world
  belongs_to :parent, polymorphic: true
  belongs_to :owner, polymorphic: true, optional: true
  has_many :children, class_name: 'GeoLayer', foreign_key: :parent_id

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

  scope :for_world, ->(w) { where world: w }

  add_geo_layer_level :continent
  add_geo_layer_level :subcontinent
  add_geo_layer_level :region
  add_geo_layer_level :area
  add_geo_layer_level :province
  # Hex is too much
  # add_geo_layer_level :hex
end
