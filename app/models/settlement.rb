class Settlement < ApplicationRecord
  resourcify
  # has_many :hexes, as: :owner
  belongs_to :world
  belongs_to :hex
  belongs_to :owner, class_name: 'State'
  has_many :buildings, as: :location

  scope :for_world, -> (world) { where world: world }

  BASE_VALUE_BY_TYPE = {
    thorp: 50.0,
    hamlet: 200.0,
    village: 500.0,
    small_town: 1000.0,
    large_town: 2000.0,
    small_city: 4000.0,
    large_city: 8000.0,
    metropolis: 16000.0
  }

  TYPE_MODIFIERS = [
    :modifiers,
    :qualities,
    :danger,
    :purchase_limit
  ]

  MODIFIERS_BY_TYPE = {
    thorp: { modifiers: -4, qualities: 1, danger: -10, purchase_limit: 500.0 },
    hamlet: { modifiers: -2, qualities: 1, danger: -5, purchase_limit: 1000.0 },
    village: { modifiers: -1, qualities: 2, danger: 0, purchase_limit: 2500.0 },
    small_town: { modifiers: 0, qualities: 2, danger: 0, purchase_limit: 5000.0 },
    large_town: { modifiers: 0, qualities: 3, danger: 5, purchase_limit: 10000.0 },
    small_city: { modifiers: 1, qualities: 4, danger: 5, purchase_limit: 25000.0 },
    large_city: { modifiers: 2, qualities: 5, danger: 10, purchase_limit: 50000.0 },
    metropolis: { modifiers: 4, qualities: 6, danger: 10, purchase_limit: 100000.0 }
  }

  GOVERNMENT_MODIFIERS = {
    autocracy: {},
    colonial: { corruption: 2, law: 1, economy: 1 },
    council: { society: 4, law: -2, lore: -2 },
    military: { law: 3, corruption: -1, society: -1 },
    overlord: { corruption: 2, law: 2, crime: -2, society: -2 },
    secret_syndicate: { corruption: 2, economy: 2, crime: 2, law: -6 }
  }

  def lot_count
    buildings.map(&:lots).reduce(0, :+)
  end

  def control_dc
    # lots / 36
    lot_count / 36.0
  end

  def area_in_square_miles
    # lots / 36
    lot_count / 36.0
  end

  def population_capacity
    # lots * 250
    lot_count * 250.0
  end

  def settlement_type
    case (population || 0)
    when 0..21 # thorp
      :thorp
    when 21..60 # hamlet
      :hamlet
    when 61..200 # village
      :village
    when 201..2000 # small town
      :small_town
    when 2001..5000 # large town
      :large_town
    when 5001..10000 # small city
      :small_city
    when 10001..25000 # large city
      :large_city
    else # metropolis and beyond
      :metropolis
    end
  end

  def base_value
    base = BASE_VALUE_BY_TYPE[settlement_type]

    # add a bonus for really large cities
    base + ([(population || 0) - 25000, 0].max) / 25000
  end

  def building_bonuses
    bonuses = buildings.map do |b|
      b.building_type.settlement_bonus || {}
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

  def unrest
    building_bonuses[:unrest]
  end

  def stability
    building_bonuses[:stability]
  end

  def economy
    building_bonuses[:economy]
  end

  def modifiers
    MODIFIERS_BY_TYPE[settlement_type]
  end
end
