class WorldGenerator < ApplicationRecord
  belongs_to :world, optional: true
  belongs_to :user
end
