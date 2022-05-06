class UnitType < ApplicationRecord
  include ScopedToWorld

  has_many :units
  belongs_to :state, optional: true
end
