class GeoLayer < ApplicationRecord
  belongs_to :world
  belongs_to :parent, polymorphic: true
  has_many :children, class_name: 'GeoLayer', foreign_key: :parent_id
end
