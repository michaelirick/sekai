ActiveAdmin.register Culture do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :color, :world_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :color, :world_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  controller do
    before_action :check_for_world

    def check_for_world
      redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end

  show do |s|
    attributes_table do
      row :title
      row :color
      row :owner
      # row :descendants
      # row :ancestors
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :color, as: :color
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
    end

    f.actions
  end

  action_item :reset_geometry, only: [:show] do
    link_to 'Reset Geometry', reset_geometry_admin_culture_path(culture)
  end

  member_action :reset_geometry, method: :get do
    if resource.nil?
      redirect_to resource_path, notice: 'You cannot reset this geometry.'
    else
      begin
        resource.reset_geometry!
        redirect_to resource_path, notice: "You have reset #{resource.title}."
      rescue => e
        redirect_to resource_path, alert: "There was an error"
      end
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :color
    # column :ancestors
    # column :descendants

    actions
  end
end
