ActiveAdmin.register Province do
  menu parent: 'geography', priority: 2, if: proc{true}
  permit_params :title, :parent_type, :parent_id, :world_id

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :parent_id, as: :select, collection: GeoLayer.areas_for(current_user.selected_world)
      f.input :parent_type, as: :hidden, input_html: {value: 'GeoLayer'}
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  member_action :reset_geometry, method: [:post] do
    resource.reset_geometry!
    redirect_to admin_province_path(resource)
  end

  index do
    selectable_column
    column :title
    column :parent
    column :owner

    actions defaults: true do |h|
      link_to 'Reset Geometry', reset_geometry_admin_province_path(h), method: 'post', class: 'member_link'
    end
  end


  controller do
    before_action :check_for_world

    def check_for_world
      redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end
end
