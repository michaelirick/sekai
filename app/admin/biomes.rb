ActiveAdmin.register Biome do
  extend Mappable
  add_reset_geometry!
  add_update_boundaries!
  check_for_world!
  add_pages!
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


  show do |s|
    attributes_table do
      row :title
      row :color
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
