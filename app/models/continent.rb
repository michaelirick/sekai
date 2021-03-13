class Continent < ApplicationRecord
  has_many :subcontinents
  belongs_to :world
end
