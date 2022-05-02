class Building < ApplicationRecord
  belongs_to :building_type
  belongs_to :location, polymorphic: true, optional: true
  belongs_to :owner, polymorphic: true, optional: true
  belongs_to :world

  scope :for_world, -> (world) { where world: world }

  delegate :lots, to: :building_type
  delegate :cost, to: :building_type
  delegate :faction_bonus, to: :building_type
  delegate :settlement_bonus, to: :building_type
end
