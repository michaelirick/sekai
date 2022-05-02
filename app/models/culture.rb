class Culture < ApplicationRecord
  include Geometriable
  include UniqueColor
  include ScopedToWorld

  belongs_to :world

  # has_many :ancestor_groups, class_name: 'CultureGroup', foreign_key: :child_id
  # has_many :ancestors, class_name: 'Culture', through: :ancestor_groups
  # has_many :descendant_groups, class_name: 'CultureGroup', foreign_key: :parent_id
  # has_many :descendants, class_name: 'Culture', through: :descendant_groups
  has_many :hexes

  after_commit :ensure_color_generated

  def has_unique_color?
    world.cultures.where.not(id: id).where(color: color).count == 0
  end

  def new_geometry_query
    %(
      SELECT st_asgeojson(st_union(a.new_geometry)) AS new_geometry
from
      (SELECT st_asgeojson(st_union(geometry)) AS new_geometry
      FROM geo_layers
      WHERE culture_id=#{id} AND world_id=#{world.id}) a
                                               )
  end
end
