ActiveAdmin.register Region do
  menu parent: 'geography', priority: 4, if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :subcontinent_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :subcontinent_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :subcontinent, collection: Subcontinent.for_world(current_user.selected_world)
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
