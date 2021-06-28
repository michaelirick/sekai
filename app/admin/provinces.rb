ActiveAdmin.register Province do
  menu parent: 'geography', priority: 2, if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :area_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :area_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :area, collection: Area.for_world(current_user.selected_world)
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
