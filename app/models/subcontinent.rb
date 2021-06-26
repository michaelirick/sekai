class Subcontinent < ApplicationRecord
  has_many :regions
  belongs_to :continent

  scope :for_world, ->(w) do
    joins(continent: :world).where(
      continents: {world: w}
    )
  end
end
