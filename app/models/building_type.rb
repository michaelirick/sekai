class BuildingType < ApplicationRecord
  has_many :buildings
  belongs_to :upgrade, optional: true, class_name: 'BuildingType'

  def settlement_bonus
    (super || {}).symbolize_keys
  end

  def faction_bonus
    (super || {}).symbolize_keys
  end
end
