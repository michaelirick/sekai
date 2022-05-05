class GeoLayer < ApplicationRecord
  belongs_to :world
  belongs_to :parent, polymorphic: true
  belongs_to :owner, polymorphic: true, optional: true
  has_many :children, class_name: 'GeoLayer', as: :parent
  has_one :de_jure, class_name: 'State'
  belongs_to :culture, optional: true
  belongs_to :biome, optional: true
  belongs_to :terrain, optional: true
  attr_accessor :points

  scope :hexes, -> { where type: 'Hex' }

  HEX_RADIUS = 6.0469
  BIOME_TYPES = %w[
    polar_desert
    ice
    subpolar_dry_tundra
    subpolar_moist_tundra
    subpolar_wet_tundra
    subpolar_rain_tundra
    boreal_dry_scrub
    boreal_moist_forest
    boreal_wet_forest
    boreal_rain_forest
    cool_temperate_desert
    cool_temperate_desert_scrub
    cool_temperate_steppe
    cool_temperate_moist_forest
    cool_temperate_wet_forest
    cool_temperate_rain_forest
    warm_temperate_desert
    warm_temperate_desert_scrub
    warm_temperate_thorn_scrub
    warm_temperate_dry_forest
    warm_temperate_moist_forest
    warm_temperate_wet_forest
    warm_temperate_rain_forest
    subtropical_desert
    subtropical_desert_scrub
    subtropical_thorn_woodland
    subtropical_dry_forest
    subtropical_moist_forest
    subtropical_wet_forest
    subtropical_rain_forest
    tropical_desert
    tropical_desert_scrub
    tropical_thorn_woodland
    tropical_very_dry_forest
    tropical_dry_forest
    tropical_moist_forest
    tropical_wet_forest
    tropical_rain_forest
  ]

  TERRAIN_TYPES = %w[
    deep_ocean
    shallow_sea
    river
    lake
    plains
    hills
    mountains
    impassible_mountains
  ]

  after_commit :update_parent_geometry
  after_commit :update_owner_geometry
  after_commit :update_culture_geometry
  after_commit :update_biome_geometry
  after_commit :ensure_color_generated

  def ensure_color_generated
    if color.nil? || !has_unique_color?
      generate_color!
    end
  end

  def generate_color!
    range = %w[0 1 2 3 4 5 6 7 8 9 a b c d e f]
    self.color = '#' + 6.times.map { |i| range.sample }.join
    save!
  end

  def has_unique_color?
    world.geo_layers.where.not(id: id).where(color: color).count == 0
  end

  def change_geometry_for_parent?
    previous_changes[:geometry] || previous_changes[:parent_id] || previous_changes[:parent_type] || destroyed? || previously_new_record?
  end

  def all_hexes
    geo_layer = GeoLayer.arel_table
    Hex.where(world: world).where(geo_layer[:geometry].st_intersects(geometry))
  end

  def change_geometry_for_culture?
    previous_changes[:geometry] || previous_changes[:culture_id] || previous_changes[:owner_id] || destroyed? || previously_new_record?
  end

  def update_culture_geometry
    puts "changes", self.points
    return unless culture

    if change_geometry_for_culture?
      culture.reset_geometry!
    end
  end

  def update_biome_geometry
    return unless culture

    if change_geometry_for_biome?
      biome.reset_geometry!
    end
  end

  def change_geometry_for_biome?
    previous_changes[:geometry] || previous_changes[:biome_id] || previous_changes[:owner_id] || destroyed? || previously_new_record?
  end

  def update_parent_geometry
    puts 'update_parent_geometry'
    unless parent
      puts "no parent"
      return
    end
    if parent_type == 'World'
      puts 'parent is World'
    end

    if change_geometry_for_parent?
      puts 'parent changed'
      parent.reset_geometry!
    end
    puts "changes:"
    # puts self.methods.sort
  end

  def change_geometry_for_owner?
    previous_changes[:geometry] || previous_changes[:owner_type] || previous_changes[:owner_id] || destroyed? || previously_new_record?
  end
  def update_owner_geometry
    puts 'update_owner_geometry'
    unless owner
      puts "no owner"
      return
    end
    if owner_type == 'World'
      puts 'owner is World'
    end

    if change_geometry_for_owner?
      puts 'owner changed'
      owner.reset_geometry!
    end
    puts "changes:"
    # puts self.methods.sort
  end

  def self.add_geo_layer_level(layer)
    @geo_layer_levels = [] unless @geo_layer_levels
    @geo_layer_levels << layer
    scope :"#{layer.to_s.pluralize}_for", -> (world) { where(type: layer.to_s.classify, world: world) }
  end

  def self.geo_layer_levels
    @geo_layer_levels
  end

  def self.for(world)
    @geo_layer_levels.map do |layer|
      { layer.to_s.pluralize.to_sym => send(:"#{layer.to_s.pluralize}_for", world) }
    end.reduce :merge
  end

  def factory
    world.factory
  end

  def all_children_ids
    (children.map(&:id) + children.map(&:all_children_ids)).flatten.uniq
  end

  def self.reset_geometry_for!(world, options={})
    classes = [Hex, Province, Area, Region, Subcontinent, Continent]
    classes -= options[:except] || []
    classes.each do |c|
      puts "Resetting #{c}..." if ENV['DEBUG'] == '1'
      c.where(world: world).each &:reset_geometry!
    end
  end


  def self.hex_geometry(points, factory)
    points = points.map do |p|
      px, py = p
      factory.point(px, py)
    end

    geometry_from_points points, factory
  end

  def reset_hex!
    self.geometry = world.hex_geometry world.draw_hex(world.hex_to_point(x, y))
    save!
  end

  def reset_geometry!
    if type == 'Hex'
      reset_hex!
      return
    end
    query = %(
      SELECT st_asgeojson(st_union(a.new_geometry)) AS new_geometry
        from
      (SELECT st_union(geometry) AS new_geometry
      FROM geo_layers
      WHERE parent_id=#{id} AND parent_type='GeoLayer') a
                                               )
    new_geometry = GeoLayer.connection.execute(query).map(&:to_h).first['new_geometry']

    polygons = children.pluck(:geometry).compact.map(&:to_a).flatten

    new_geometry = RGeo::GeoJSON.decode new_geometry
    self.geometry = factory.collection [new_geometry].compact
    self.save!
  rescue => e
    puts "#{type} #{id} #{title} failed to reset geometry:"
    puts e.full_message
  end

  def update_geometry!(points)
    puts "points: #{points.inspect}"
    points = points.map do |x, y|
      factory.point(x, y)
    end

    self.geometry = factory.collection [factory.polygon(factory.linear_ring(points))]
    save!
  end

  def area
    GeoLayer.connection.execute(%(
    SELECT st_area(geometry)
    from geo_layers WHERE id=#{id}
                                )).first['st_area']
  end

  # generates a number of random points within the bounds of the geometry
  def generate_points(n = 12)
    points = GeoLayer.connection.execute(%(
    select st_asgeojson(b.points) as points
    from (
      select st_generatepoints(a.shapes, #{n}, #{rand(1000)}) as points
      from (select st_collectionextract(geometry, 3) as shapes
      from geo_layers where id=#{id}) a
    ) b
                                )).first['points']
    RGeo::GeoJSON.decode(points).elements.map(&:coordinates)
  end

  def bounding_box
    box = GeoLayer.connection.execute(%(
    SELECT st_asgeojson(box2d(geometry)) as box
    from geo_layers WHERE id=#{id}
                                )).first['box']
    RGeo::GeoJSON.decode(box)
  end

  def hex_coordinates_within_bounding_box
    points = bounding_box.exterior_ring.points.map(&:coordinates)[0...-1]
    low_x = points.map(&:first).min
    high_x = points.map(&:first).max
    low_y = points.map(&:last).min
    high_y = points.map(&:last).max

    result = []
    (low_x..high_x).step(6) do |x|
      (low_y..high_y).step(6) do |y|
        result << world.point_to_hex(x, y)
      end
    end
    # generate_points(area.to_i / 10).map do |point|
    #   GeoLayer.point_to_hex *point
    # end.uniq.compact
    result.uniq.compact
  end

  def hexes_existing_in_bounding_box
    hexes = hex_coordinates_within_bounding_box
    hexes_string = hexes.map {|x,y| "(#{x},#{y})"}.join(', ')
    Hex.connection.execute(%(
    select g.* from geo_layers g
    join (values #{hexes_string}) t(x,y)
      on g.x = t.x and g.y = t.y and g.type = 'Hex' and g.world_id=#{world_id}
                           ))
  end

  def hexes_within_geometry
    geo_layer = GeoLayer.arel_table
    Hex.where(world: world).where(geo_layer[:geometry].st_intersects(geometry))
  end

  def assign_hexes_within_geometry!
    hexes_within_geometry.each do |h|
      h.parent = self
      h.save!
    end
  end

  # generates non-existing hexes within its bounding box
  def generate_hexes!
    GeoLayer.transaction do
      new_hexes = hex_coordinates_within_bounding_box - hexes_existing_in_bounding_box.pluck('x', 'y')
      new_colors = UniqueColor.allocate_color(world, 'geo_layers', 'color', new_hexes.count)
      new_hexes = new_hexes.map.with_index do |coords, i|
        x, y = coords
        {
          color: new_colors[i],
          parent_id: id,
          world_id: world.id,
          type: 'Hex',
          parent_type: 'GeoLayer',
          x: x,
          y: y,
          geometry: world.hex_geometry(world.draw_hex(world.hex_to_point(x, y))),
          created_at: Time.now,
          updated_at: Time.now
        }
      end

      new_hexes.each_slice(24) do |slice|
        Hex.insert_all slice
      end
    end

    reset_geometry!
  end

  scope :for_world, ->(w) { where world: w }

  add_geo_layer_level :continent
  add_geo_layer_level :subcontinent
  add_geo_layer_level :region
  add_geo_layer_level :area
  add_geo_layer_level :province
  # Hex is too much
  # add_geo_layer_level :hex
end
