ActiveAdmin.register World do
  menu parent: 'geography', priority: 7, if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :resolution_x, :resolution_y, :circumference
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  controller do
    before_action do
      ActiveStorage::Current.host = request.base_url
    end

    def scoped_collection
      end_of_association_chain.where(user_id: current_user.id)
    end

    def map
      world = World.find params[:id]
      mode = params[:mapMode] || 'continents'
      x, y = if params[:center]
        params[:center].try(:split, ',').map &:to_i
      else
        [0 ,0]
      end
      zoom = params[:zoom].to_i + 5
      zoom = 1 if zoom < 1
      puts "zoom: #{zoom}"
      w = 400
      h = 200
      cells = []
      geo_layer_type = mode.singularize.titleize
      box = world.factory.polygon world.factory.linear_ring([
        world.factory.point(x - w, y - h),
        world.factory.point(x - w, y + h),
        world.factory.point(x + w, y + h),
        world.factory.point(x + w, y - h)
                                                            ])
      cell = Struct.new(:type, :id, :title, :color, :geometry)
      if mode == 'hexes'
        x, y = world.point_to_hex x, y
        puts 'new xy', x, y
        if false #zoom < 5
          cells = []
        else
          w = case zoom
              when 7
                35
              when 8
                20
              when 9
                10
              when 10
                5
              else
                0
              end
          # x, y = GeoLayer.point_to_hex x, y
          h = 35#10 * (zoom - 3)
          # w = 2048 / (2**zoom)#10 * (zoom - 3)
          h = w
          puts 'box', w, h
          puts 'pixels', 2 ** zoom * 256
          cells = world.geo_layers.where(type: 'Hex').where(
            "x > ? AND x < ? AND y > ? AND y < ?",
            x - w, x + w, y - h, y + h
          )
          # cells = world.geo_layers.where(type: geo_layer_type).where("ST_Intersects(ST_geomfromtext('#{box}'), geo_layers.geometry)")
          # cells = world.geo_layers.where(type: 'Hex').where("ST_distance(geometry, ST_GeomFromText('POINT((#{x} #{y}))')) < 100")
          # cells = world.geo_layers.where(type: 'Hex')
        end
      elsif mode == 'states'
        cells = world.states
      elsif mode == 'independent_states'

        cells = world.states.where(owner_id: nil).map do |s|
          cell.new('State', s.id, s.name, s.primary_color, s.realm_geometry)
        end
      elsif mode == 'settlements'
        cells = world.settlements.map do |s|
          cell.new('Settlement', s.id, s.name, 'dark gray', s.hex.geometry)
        end
      elsif mode == 'cultures'
        cells = world.cultures.map do |c|
          cell.new('Culture', c.id, c.title, c.color, c.geometry)
        end
      elsif mode == 'biomes'
        cells = world.biomes.map do |b|
          cell.new('Biome', b.id, b.title, b.color, b.geometry)
        end
      else
        puts box

        geo_layers = GeoLayer.arel_table
        cells = world.geo_layers.where(type: geo_layer_type)#.where("ST_Intersects(ST_geomfromtext('#{box}'), geo_layers.geometry)")

        #.where(geo_layers[:geometry].st_contains(box))


      end
      # cells = MapLayer.first.polygons.map do |p|
      #   cell.new(
      #     'test',
      #     1,
      #     'test',
      #     '#333333',
      #     RGeo::GeoJSON.decode(p['st_asgeojson'])
      #   )
      # end
      # cells = world.geo_layers.where(type: geo_layer_type)
      cells = cells.map do |c|
        {
          id: c.id,
          name: c.try(:title) || c.try(:name),
          points: RGeo::GeoJSON.encode(c.geometry),
          layer: mode,
          type: c.type,
          color: c.try(:color) || c.try(:primary_color),
          hex_radius: world.hex_radius
        }
      end
      puts cells.count
      # hexes = Hex.all
      # range = 500
      # zoom = params[:zoom].to_i

      # x, y = if params[:center]
      #   params[:center].try(:split, ',').map &:to_i
      # else
      #   [0 ,0]
      # end

      # # TODO: scope to world
      # hexes = Hex.viewable_on_map_at(world, x, y, zoom).map do |h|
      #   Hexes::Index.new(h).to_json
      # end
      hexes = []



      render json: {cells: cells}
    end
  end

  show do |w|
    attributes_table do
      row :name
      row :resolution_x
      row :resolution_y
      row :circumference
      row :created_at
    end

    tabs do
      tab 'Map' do
        react_component 'Map/index', { world: Worlds::Show.new(w).to_json }
      end
      tab 'Approximations' do
        attributes_table 'Approx. Sizes' do
          row :approx_hex_count
          row :approx_province_count
          row :approx_area_count
          row :approx_region_count
          row :approx_subcontinent_count
          row :approx_continent_count
        end
      end
    end
  end

  member_action :select_world, method: :get do
    if resource.user.nil?
      redirect_to resource_path, notice: 'You cannot select this world.'
    else
      u = resource.user
      u.selected_world = resource
      if u.save
        redirect_to resource_path, notice: "You have selected #{resource.name}."
      else
        redirect_to resource_path, notice: "There was an error trying to select that world."
      end
    end
  end

  action_item :select_world, only: [:show] do
    # if current_user.can?(:select_world, character)
      link_to 'Select World', select_world_admin_world_path(world)
    # end
  end

  index do
    selectable_column
    id_column
    column :name

    actions defaults: true do |world|

      link_to 'Select World', select_world_admin_world_path(world), class: 'member_link'
    end
  end

end
