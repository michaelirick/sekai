class Province < ApplicationRecord
  include GeoLayerable
  resourcify
  has_many :hexes
  belongs_to :area
  add_geo_layer(
    name: 'Province',
    parent: :area,
    subordinates: :hexes
  )

  scope :for_world, ->(w) do
    joins(area: {region: {subcontinent: {continent: :world}}}).where(
      areas: {regions: {subcontinents: {continents: {world: w}}}}
    )
  end

  def cached_points
    self[:cached_points]
  end

  def cached_points=(t)
    self[:cached_points] = t
  end
end
