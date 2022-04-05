class GeoLayer < ApplicationRecord
  belongs_to :world
  belongs_to :parent, polymorphic: true
  belongs_to :owner, polymorphic: true, optional: true
  has_many :children, class_name: 'GeoLayer', foreign_key: :parent_id

  def self.add_geo_layer_level(layer)
    scope :"#{layer.to_s.pluralize}_for", -> (world) { where(type: layer.to_s.classify, world: world) }
  end

  scope :for_world, ->(w) { where world: w }

  add_geo_layer_level :continent
  add_geo_layer_level :subcontinent
  add_geo_layer_level :region
  add_geo_layer_level :area
  add_geo_layer_level :province
end
