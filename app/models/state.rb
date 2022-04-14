class State < ApplicationRecord
  include ReducibleAssociation
  resourcify
  has_many :hexes, as: :owner
  belongs_to :world
  has_many :buildings, as: :owner
  has_many :settlements, foreign_key: :owner_id

  scope :for_world, -> (world) { where world: world }

  add_reducer :settlements, :+, 'sum'

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

  def consumption
    hexes.count * Statistic::MONEY_PER_BP # TODO: add settlement and building
  end

  def control_dc
    20.0 + hexes.count + settlement_control_dc
  end

  def settlement_control_dc
    sum_settlements :control_dc || 0.0
  end

  def effective_unrest
    unrest + sum_settlements(:unrest)
  end

  # TODO: leader effects
  def effective_stability
    stability + sum_settlements(:stability)
  end

  def effective_economy
    economy + sum_settlements(:economy)
  end

  def upkeep!
    stability_check!
  end

  def stability_check!

  end

  def stability_tab
    es = effective_stability
    dc = control_dc
    delta = dc - es
    chance = 1 - (delta.to_f / 20)
    {
      effective_stability: es,
      control_dc: dc,
      success_chance: "#{(chance * 100).clamp(0, 100)}%",
      on_success: (unrest - 1 < 0) ? "Money +#{Statistic::MONEY_PER_BP}" : 'Unrest -1',
      on_failure: delta < -4 ? 'Unrest +1d4' : 'Unrest +1'
    }
  end

  def consumption_tab
    consumption_value = consumption
    {
      consumption: consumption_value,
      money_left: money - consumption_value,
      effects: (money - consumption_value > 0) ? 'None' : 'Unrest +2'
    }
  end

  def upkeep_unrest_tab
    results = {}

    %i[stability economy loyalty].each do |stat|
      results[stat] = '+1' if send(stat) < 0
    end

    if unrest > 19
      result[:unrest] = 'Anarchy imminent'
    elsif unrest > 10
      result[:unrest] = 'Hex loss imminent'
    end

    results
  end

  # TODO: this aint right
  def income_taxes_tab
    ee = effective_economy
    dc = control_dc
    delta = [0, (ee - dc)].max

    {
      low_estimate: delta * Statistic::MONEY_PER_BP / 3.0,
      average: (10.5 + delta) * Statistic::MONEY_PER_BP / 3.0,
      high_estimate: (20 + delta) * Statistic::MONEY_PER_BP / 3.0
    }
  end
end
