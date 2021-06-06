class MapLayer < ApplicationRecord
  belongs_to :world

  has_one_attached :image
end
