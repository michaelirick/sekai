class Subcontinent < GeoLayer
  # include GeoLayerable
  # resourcify
  # has_many :regions
  # belongs_to :continent
  # add_geo_layer(
  #   name: 'Subcontinent',
  #   parent: :continent,
  #   subordinates: :regions
  # )
  # # inverse mapping to the relation needed to group
  # %i[
  #   areas
  #   provinces
  # ].each do |sub|
  #   define_method sub do
  #     geo_subordinates.map(&sub).flatten
  #   end
  # end

  # scope :for_world, ->(w) do
  #   joins(continent: :world).where(
  #     continents: {world: w}
  #   )
  # end
end
