class Area < ApplicationRecord
  has_many :provinces
  belongs_to :region
end
