class Region < ApplicationRecord
  has_many :areas
  belongs_to :subcontinent
end
