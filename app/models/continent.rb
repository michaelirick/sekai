class Continent < GeoLayer
  # include GeoLayerable
  # resourcify
  # has_many :subcontinents
  # belongs_to :world
  # add_geo_layer(
  #   name: 'Continent',
  #   parent: :world,
  #   subordinates: :subcontinents
  # )
  # # inverse mapping to the relation needed to group
  # %i[
  #   regions
  #   areas
  #   provinces
  # ].each do |sub|
  #   define_method sub do
  #     geo_subordinates.map(&sub).flatten
  #   end
  # end
  # scope :for_world, -> (w) { where(world: w) }
end
