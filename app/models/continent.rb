class Continent < ApplicationRecord
  has_many :subcontinents
  belongs_to :world

  scope :for_world, -> (w) { where(world: w) }
end
