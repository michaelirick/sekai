ActiveAdmin.register Subcontinent do
  extend Mappable

  menu parent: 'geography', priority: 5, if: proc{true}
  permit_params :title, :parent_type, :parent_id, :world_id, :points

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :parent_id, as: :select, collection: GeoLayer.continents_for(current_user.selected_world)
      f.input :parent_type, as: :hidden, input_html: {value: 'GeoLayer'}
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end


  add_reset_geometry!
  add_update_boundaries!
  check_for_world!

  index do
    selectable_column
    column :title
    column :parent
    column :owner

    actions defaults: true do |h|
      link_to 'Reset Geometry', reset_geometry_admin_subcontinent_path(h), method: 'post', class: 'member_link'
    end
  end

end
