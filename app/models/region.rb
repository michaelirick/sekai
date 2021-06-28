class Region < ApplicationRecord
  resourcify
  has_many :areas
  belongs_to :subcontinent

  scope :for_world, ->(w) do
    joins(subcontinent: {continent: :world}).where(
      subcontinents: {continents: {world: w}}
    )
  end
end
