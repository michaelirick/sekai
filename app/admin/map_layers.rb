ActiveAdmin.register MapLayer do
  menu parent: 'geography', priority: 100, if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :world_id, :image, :world, :priority
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :world_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors
    f.inputs do
      input :title
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
      input :image, as: :file
      input :priority
    end

    actions
  end

  show do |m|
    attributes_table do
      row :title
      row :world
      row :priority
      row :created_at
      row :updated_at
      row :image do |ad|
        image_tag url_for(ad.image)
      end
    end
  end

  controller do
    before_action :check_for_world

    def check_for_world
      redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end
end
