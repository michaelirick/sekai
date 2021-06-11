ActiveAdmin.register Hex do
  menu parent: 'geography', priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :world_id, :x, :y, :owner_id, :province_id, :terrain_type
  #
  # or
  #
  # permit_params do
  #   permitted = [:world_id, :x, :y, :owner_id, :province_id, :terrain_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  controller do
    def map
      # TODO: scope to world
      hexes = Hex.all
      range = 500
      zoom = params[:zoom].to_i

      x, y = if params[:center]
        params[:center].try(:split, ',').map &:to_i
      else
        [0 ,0]
      end

      render json: Hex.viewable_on_map_at(x, y, zoom)
    end
  end
end
