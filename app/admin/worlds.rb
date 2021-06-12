ActiveAdmin.register World do
  menu parent: 'geography', priority: 7

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  controller do
    before_action do
      ActiveStorage::Current.host = request.base_url
    end

    def map
      world = World.find params[:id]
      hexes = Hex.all
      range = 500
      zoom = params[:zoom].to_i

      x, y = if params[:center]
        params[:center].try(:split, ',').map &:to_i
      else
        [0 ,0]
      end

      # TODO: scope to world
      hexes = Hex.viewable_on_map_at(world, x, y, zoom).map do |h|
        Hexes::Index.new(h).to_json
      end

      render json: hexes
    end
  end

  show do |w|
    attributes_table do
      row :name
      row :created_at
    end

    tabs do
      tab 'Continents' do
        table_for w.continents do
          column :id
          column :name
        end
      end

      tab 'Map' do
        react_component 'Map/index', { world: Worlds::Show.new(w).to_json }
      end
    end
  end

end
