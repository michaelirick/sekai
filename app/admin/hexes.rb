ActiveAdmin.register Hex do
  menu parent: 'geography', priority: 1, if: proc{true}
  permit_params :title, :parent_type, :parent_id, :world_id, :x, :y

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :parent_id, as: :select, collection: GeoLayer.provinces_for(current_user.selected_world)
      f.input :parent_type, as: :hidden, input_html: {value: 'GeoLayer'}
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
      f.input :x
      f.input :y
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end

  member_action :update_boundaries, method: [:post] do
    # binding.pry
    # resource.reset_geometry!
    resource.update_geometry! params[:points]
    # resource.update_attributes! foo: params[:foo] || {}
    redirect_to admin_hex_path(resource)
  end

  index do
    selectable_column
    id_column
    column :title
    column :parent
    column :x
    column :y
    column :owner

    # actions defaults: true do |h|
    #   link_to 'Reset Geometry', update_boundaries_admin_hex_path(h), method: 'post', class: 'member_link'
    # end
  end

  controller do
    before_action :check_for_world

    def check_for_world
      puts "current_user: #{current_user.inspect}"
      # redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end
end
