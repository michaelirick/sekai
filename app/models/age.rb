class Age < ApplicationRecord
  has_many :world_dates
  belongs_to :world
  belongs_to :preceding_age, class_name: 'Age', optional: true
  belongs_to :start_date, class_name: 'WorldDate', optional: true

  scope :for_world, ->(w) { where(world: w) }
end
