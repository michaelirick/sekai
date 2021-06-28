ActiveAdmin.register Area do
  menu parent: 'geography', priority: 3, if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :region_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :region_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :region, collection: Region.for_world(current_user.selected_world)
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

end
