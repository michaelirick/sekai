class Region < GeoLayer
  # include GeoLayerable
  # resourcify
  # has_many :areas
  # belongs_to :subcontinent
  # add_geo_layer(
  #   name: 'Region',
  #   parent: :subcontinent,
  #   subordinates: :areas
  # )
  # # inverse mapping to the relation needed to group
  # %i[
  #   provinces
  # ].each do |sub|
  #   define_method sub do
  #     geo_subordinates.map(&sub).flatten
  #   end
  # end
  # scope :for_world, ->(w) do
  #   joins(subcontinent: {continent: :world}).where(
  #     subcontinents: {continents: {world: w}}
  #   )
  # end
end
