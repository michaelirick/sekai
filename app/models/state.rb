class State < ApplicationRecord
  has_many :hexes, as: :owner
  belongs_to :world
end
