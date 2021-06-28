class MapLayer < ApplicationRecord
  resourcify
  belongs_to :world

  has_one_attached :image
end
