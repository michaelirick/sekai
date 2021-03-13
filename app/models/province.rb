class Province < ApplicationRecord
  has_many :hexes
  belongs_to :area
end
