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

end
