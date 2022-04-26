ActiveAdmin.register Hex do
  menu parent: 'geography', priority: 1, if: proc{true}
  permit_params :title, :parent_type, :parent_id, :world_id, :x, :y, :owner_type, :owner_id, :biome_id, :terrain_id, :color, :culture_id

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :parent_id, as: :select, collection: GeoLayer.provinces_for(current_user.selected_world)
      f.input :parent_type, as: :hidden, input_html: {value: 'GeoLayer'}
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
      f.input :x
      f.input :y
      f.input :biome_id, as: :select, collection: Biome.all.sort
      # f.input :terrain_id, as: :select, collection: Terrain.all.sort
      f.input :color
      f.input :culture_id, as: :select, collection: Culture.for_world(current_user.selected_world)
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
    link_to 'Reset Geometry', reset_geometry_admin_hex_path(hex)
  end

  member_action :update_boundaries, method: [:post] do
    # binding.pry
    # resource.reset_geometry!
    resource.update_geometry! params[:points]
    # resource.update_attributes! foo: params[:foo] || {}
    redirect_to resource
  end

  index do
    selectable_column
    id_column
    column :title
    column :parent
    column :x
    column :y
    column :owner
    column :biome
    column :terrain
    column :color

    actions defaults: true do |h|
      # link_to 'Reset Geometry', update_boundaries_admin_hex_path(h), method: 'post', class: 'member_link'
    end
  end

  controller do
    before_action :check_for_world

    def check_for_world
      puts "current_user: #{current_user.inspect}"
      # redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end

    def biomes
      biomes = GeoLayer::BIOME_TYPES.map do |biome|
        {
          value: biome,
          label: biome.titleize
        }
      end

      render json: biomes
    end

    def terrains
      render json: GeoLayer::TERRAIN_TYPES.map do |terrain|
        {
          id: terrain,
          title: terrain.titleize
        }
      end
    end
  end
end
