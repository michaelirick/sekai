class World < ApplicationRecord
  resourcify
  has_many :states
  has_many :continents
  has_many :map_layers
  has_many :hexes
  belongs_to :user

  scope :for_user, -> (user) { where(user: user) }


  # inverse mapping to the relation needed to group
  %i[
    subcontinents
    regions
    areas
    provinces
  ].each do |sub|
    define_method sub do
      continents.map(&sub).flatten
    end
  end

  def subcontinents
    continents.map(&:subcontinents)
  end
end
