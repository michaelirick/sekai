ActiveAdmin.register WorldDate do
  menu parent: :history

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :year, :month, :day, :age_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:year, :month, :day, :age_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
