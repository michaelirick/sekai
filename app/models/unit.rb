class Unit < ApplicationRecord
  include ScopedToWorld

  belongs_to :unit_type
  belongs_to :force
  belongs_to :state
end
