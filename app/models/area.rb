class Area < ApplicationRecord
  include GeoLayerable
  resourcify
  has_many :provinces
  belongs_to :region
  add_geo_layer(
    name: 'Area',
    parent: :region,
    subordinates: :provinces
  )

  scope :for_world, ->(w) do
    joins(region: {subcontinent: {continent: :world}}).where(
      regions: {subcontinents: {continents: {world: w}}}
    )
  end
end
