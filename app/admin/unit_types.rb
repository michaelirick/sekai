ActiveAdmin.register UnitType do
  menu parent: 'Military'
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
  permit_params :title, :world_id
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
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :title

    actions
  end
end
