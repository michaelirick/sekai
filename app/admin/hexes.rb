ActiveAdmin.register Hex do
  menu parent: 'geography', priority: 1, if: proc{true}
  permit_params :title, :parent_type, :parent_id, :world_id, :geometry

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :parent_id, as: :select, collection: GeoLayer.subcontinents_for(current_user.selected_world)
      f.input :parent_type, as: :hidden, input_html: {value: 'GeoLayer'}
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
      f.input :geometry, as: :text
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  # member_action :update_boundaries, method: [:post] do
  #   # binding.pry
  #   # resource.update_boundaries! params[:points]
  #   # resource.update_attributes! foo: params[:foo] || {}
  #   head :ok
  # end
end
