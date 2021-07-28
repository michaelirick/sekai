class MapLayer < ApplicationRecord
  resourcify
  belongs_to :world

  has_one_attached :image
  scope :for_world, -> (w) { where(world_id: w) }

end
