class Force < ApplicationRecord
  include ScopedToWorld

  has_many :units
  belongs_to :location, polymorphic: true
  belongs_to :state
end
