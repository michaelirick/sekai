class State < ApplicationRecord
  resourcify
  # has_many :hexes, as: :owner
  belongs_to :world

  scope :for_world, -> (world) { where world: world }
end
