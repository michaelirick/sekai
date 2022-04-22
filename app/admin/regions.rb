ActiveAdmin.register Region do
  menu parent: 'geography', priority: 4, if: proc{true}
  permit_params :title, :parent_type, :parent_id, :world_id

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :parent_id, as: :select, collection: GeoLayer.subcontinents_for(current_user.selected_world)
      f.input :parent_type, as: :hidden, input_html: {value: 'GeoLayer'}
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  member_action :reset_geometry, method: :get do
    if resource.nil?
      redirect_to resource_path, notice: 'You cannot reset this geometry.'
    else
      begin
        resource.reset_geometry!
        redirect_to resource_path, notice: "You have reset #{resource.title}."
      rescue => e
        redirect_to resource_path, alert: "There was an error"
      end
    end
  end

  action_item :reset_geometry, only: [:show] do
    link_to 'Reset Geometry', reset_geometry_admin_region_path(region)
  end

  index do
    selectable_column
    column :title
    column :parent
    column :owner

    actions defaults: true do |h|
      link_to 'Reset Geometry', reset_geometry_admin_region_path(h), method: 'post', class: 'member_link'
    end
  end
  controller do
    before_action :check_for_world

    def check_for_world
      redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end
end
