class State < ApplicationRecord
  resourcify
  # has_many :hexes, as: :owner
  belongs_to :world
  has_many :buildings, as: :owner

  scope :for_world, -> (world) { where world: world }

  def building_bonuses
    bonuses = buildings.map do |b|
      b.building_type.faction_bonus || {}
    end

    result = {}
    bonuses.each do |b|
      b.each do |key, value|
        if result[key]
          result[key] += value
        else
          result[key] = value
        end
      end
    end

    result
  end
end
