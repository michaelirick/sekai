class Subcontinent < ApplicationRecord
  has_many :regions
  belongs_to :continent
end
