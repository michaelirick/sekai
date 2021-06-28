class Area < ApplicationRecord
  resourcify
  has_many :provinces
  belongs_to :region

  scope :for_world, ->(w) do
    joins(region: {subcontinent: {continent: :world}}).where(
      regions: {subcontinents: {continents: {world: w}}}
    )
  end
end
