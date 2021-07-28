ActiveAdmin.register Hex do
  menu parent: 'geography', priority: 1, if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :world_id, :x, :y, :owner_id, :province_id, :terrain_type, :title, :boundaries
  #
  # or
  #
  # permit_params do
  #   permitted = [:world_id, :x, :y, :owner_id, :province_id, :terrain_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :x
      f.input :y
      f.input :world
      f.input :province, collection: Province.for_world(hex.world)
      f.input :terrain_type
      f.input :owner, collection: State.for_world(hex.world)
      f.input :boundaries, as: :text do
        params[:boundaries]
      end
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  member_action :update_boundaries, method: [:post] do
    # binding.pry
    resource.update_boundaries! params[:points]
    # resource.update_attributes! foo: params[:foo] || {}
    head :ok
  end
end
