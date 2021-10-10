class GeoLayer < ApplicationRecord
  belongs_to :world
  belongs_to :parent, polymorphic: true
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

  def geometry
    RGeo::GeoJSON.encode(self[:geometry])
  end

  def factory
    RGeo::Cartesian.preferred_factory
  end

  def self.factory
    RGeo::Cartesian.preferred_factory
  end

  def compose_geometry(options = {recursive: false})
    return geometry if children.blank?

    child_geometry = children.map do |child|
      if options[:recursive]
        child.compose_geometry
      else
        child.geometry
      end
    end.reject(&:blank?)

    puts child_geometry

    factory.collection child_geometry
  end
end
