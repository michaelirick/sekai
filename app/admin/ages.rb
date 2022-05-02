ActiveAdmin.register Age do
  menu parent: :history

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :preceding_age_id, :world_id, :title, :abbreviation, :start_date_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:preceding_age_id, :world_id, :title, :abbreviation]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  controller do
    before_action :check_for_world

    def check_for_world
      redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end
end
