class State < ApplicationRecord
  include ReducibleAssociation
  resourcify
  has_many :hexes, as: :owner
  belongs_to :world
  has_many :buildings, as: :owner
  has_many :settlements, foreign_key: :owner_id
  belongs_to :owner, polymorphic: true, optional: true
  has_many :subjects, class_name: 'State', as: :owner
  belongs_to :de_jure, polymorphic: true, optional: true

  scope :for_world, -> (world) { where world: world }

  add_reducer :settlements, :+, 'sum'

  after_commit :update_owner_realm_geometry

  def type
    'State'
  end

  def de_jure_subjects(direct = true)
    [] unless de_jure

    world.states.where(de_jure: de_jure.children)
  end

  def top_owner
    return self if owner.nil?

    owner.top_owner
  end

  # all subjects and their subjects
  def realm
    subjects.map(&:realm).flatten
  end

  def de_jure_hexes
    return GeoLayer.where('1=2') unless de_jure

    de_jure.all_hexes
  end

  def owned_de_jure_hexes
    de_jure_hexes.where(owner: self)
  end

  # assigns all dejure hexes that are not also owned by their dejure owner
  def reset_de_jure!
    return unless de_jure

    subject_owned = de_jure_subjects.map(&:owned_de_jure_hexes).flatten.map(&:id)
    de_jure_hexes.where.not(id: subject_owned).each do |hex|
      hex.owner = self
      hex.save!
    end
  end

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

  def factory
    world.factory
  end

  def reset_geometry!
    new_geometry = GeoLayer.connection.execute(%(
      SELECT st_asgeojson(st_union(a.new_geometry)) AS new_geometry
from
      (SELECT st_asgeojson(st_union(geometry)) AS new_geometry
      FROM geo_layers
      WHERE owner_id=#{id} AND owner_type='State') a
                                               )).map(&:to_h).first['new_geometry']


    # polygons = subjects.pluck(:geometry).compact.map(&:to_a).flatten

    new_geometry = RGeo::GeoJSON.decode new_geometry
    self.geometry = factory.collection [new_geometry].compact
    self.save!
    reset_realm_geometry!
  rescue => e
    puts "State #{id} #{name} failed to reset geometry:"
    puts e.full_message
  end

  def reset_realm_geometry!
    if subjects.empty?
      self.realm_geometry = geometry
      self.save!
      return
    end
    new_geometry = GeoLayer.connection.execute(%(
      SELECT st_asgeojson(st_union(a.new_geometry)) AS new_geometry
from
      (SELECT st_asgeojson(st_union(realm_geometry)) AS new_geometry
      FROM states
      WHERE owner_id=#{id} AND owner_type='State'
      UNION ALL SELECT st_asgeojson(st_union(geometry)) AS new_geometry
      FROM states
      where id=#{id}
) a
                                               )).map(&:to_h).first['new_geometry']


    # polygons = subjects.pluck(:geometry).compact.map(&:to_a).flatten

    new_geometry = RGeo::GeoJSON.decode new_geometry
    self.realm_geometry = factory.collection [new_geometry].compact
    self.save!
  rescue => e
    puts "State #{id} #{name} failed to reset geometry:"
    puts e.full_message
  end

  def change_geometry_for_owner?
    previous_changes[:realm_geometry] ||previous_changes[:geometry] || previous_changes[:owner_type] || previous_changes[:owner_id] || destroyed? || previously_new_record?
  end
  def update_owner_realm_geometry
    puts 'update_owner_geometry'
    unless owner
      puts "no owner"
      return
    end
    if owner_type == 'World'
      puts 'owner is World'
    end

    if change_geometry_for_owner?
      puts 'owner changed'
      owner.reset_realm_geometry!
    end
    puts "changes:"
    # puts self.methods.sort
  end
end
