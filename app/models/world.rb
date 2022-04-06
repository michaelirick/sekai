class World < ApplicationRecord
  include GeoLayerable
  resourcify
  has_many :states
  # has_many :contine/nts
  has_many :map_layers
  has_many :geo_layers
  # has_many :hegxes
  belongs_to :user
  # add_geo_layer(
  #   name: 'World',
  #   subordinates: :continents
  # )


  scope :for_user, -> (user) { where(user: user) }

  def factory
    @factory ||= RGeo::Cartesian.factory
    @factory
  end

  # GEO_LAYER_TYPES = %i[
  #   continent
  #   subcontinent
  #   region
  #   area
  #   province
  # ].freeze

  # # inverse mapping to the relation needed to group
  # %i[
  #   subcontinents
  #   regions
  #   areas
  #   provinces
  # ].each do |sub|
  #   define_method sub do
  #     geo_subordinates.map(&sub).flatten
  #   end
  # end

  # # def subcontinents
  # #   continents.map(&:subcontinents)
  # # end

  # def geo_layers
  #   GEO_LAYER_TYPES.map do |glt|
  #     {
  #       name: glt,
  #       points: send(glt.to_s.pluralize).map do |sub|
  #         {name: sub.name, points: sub.to_geojson}
  #       end
  #     }
  #   end
  # end

  # def geo_factory
  #   RGeo::Cartesian.preferred_factory()
  # end
end
