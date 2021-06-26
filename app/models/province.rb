class Province < ApplicationRecord
  has_many :hexes
  belongs_to :area

  scope :for_world, ->(w) do
    joins(area: {region: {subcontinent: {continent: :world}}}).where(
      areas: {regions: {subcontinents: {continents: {world: w}}}}
    )
  end
end
