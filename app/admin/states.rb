ActiveAdmin.register State do
  menu parent: 'Govern'
  extend Mappable
  add_reset_geometry!
  add_update_boundaries!
  check_for_world!
  add_pages!
  config.create_another = true

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params(:name, :adjective, :world_id, :primary_color, :secondary_color,
    :stability,
    :economy,
    :loyalty,
    :unrest,
    :money,
    :government_type,
                :owner_id, :owner_type, :de_jure_id, :de_jure_type
  )
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :adjective, :world_id, :primary_color, :secondary_color]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  filter :name
  filter :primary_color

  form do |f|
    f.inputs do
      f.input :name
      f.input :adjective
      f.input :primary_color, as: :color
      f.input :secondary_color, as: :color
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
      f.input :owner_id, as: :select, collection: State.for_world(current_user.selected_world) - [state]
      f.input :owner_type, as: :hidden, input_html: {value: 'State'}

      f.input :stability
    end
    f.actions
  end

  member_action :claim, method: :post do
    format_type = request.format.symbol
    if resource.nil?
      redirect redirect_to(format: format_type), notice: 'No state such exists'
    else
      begin
        puts "good"
        resource.claim! params[:points]
        redirect_to resource_path(format: format_type), notice: "You have reset #{resource.name}."
      rescue => e
        puts "nope"
        puts e.full_message
        redirect_to resource_path(format: format_type), alert: "There was an error"
      end
    end
  end

  member_action :reset_geometry, method: :get do
    if resource.nil?
      redirect_to resource_path, notice: 'You cannot reset this geometry.'
    else
      begin
        resource.reset_geometry!
        redirect_to resource_path, notice: "You have reset #{resource.name}."
      rescue => e
        redirect_to resource_path, alert: "There was an error"
      end
    end
  end

  member_action :reset_de_jure, method: :get do
    if resource.nil?
      redirect_to resource_path, notice: 'You cannot reset this State.'
    else
      begin
        resource.reset_de_jure!
        redirect_to resource_path, notice: "You have reset #{resource.name}."
      rescue => e
        redirect_to resource_path, alert: "There was an error"
      end
    end
  end

  action_item :reset_geometry, only: [:show] do
    link_to 'Reset Geometry', reset_geometry_admin_state_path(state)
  end

  action_item :reset_de_jure, only: [:show] do
    link_to 'Reset De Jure', reset_de_jure_admin_state_path(state)
  end

  index do
    selectable_column
    id_column
    column :name
    column :owner
    column :primary_color
    column :secondary_color
    # column :de_jure
    actions
  end

  show do |s|
    attributes_table do
      row :name
      row :title do
        s.name
      end
      row :adjective
      row :owner
      row :de_jure
      row :government_type
      row :primary_color
      row :secondary_color
      row :created_at
      row :size do
        s.hexes.count
      end
      row :area do
        "#{number_with_delimiter(s.area.round)} sqmi (#{number_with_delimiter(s.area_in_km2.round)} sqkm)"
      end
      row :population do
        number_with_delimiter s.population
      end
      row :population_capacity do
        number_with_delimiter s.population_capacity
      end
      row :control_dc
      row :consumption
    end

    panel 'Statistics' do
      attributes_table_for s do
        row :stability
        row :economy
        row :loyalty
        row :unrest
        row :money
      end
    end

    tabs do
      tab 'Settlements' do
        table_for s.settlements do
          column :name do |ss|
            link_to ss.name, [:admin, ss]
          end
          column :settlement_type do |ss|
            ss.settlement_type.to_s.titleize
          end
          column :location do |ss|
            link_to ss.hex.title, [:admin, ss.hex]
          end
        end
      end
      tab 'Buildings' do
        tabs do
          tab 'Buildings' do
            table_for s.buildings do
              column :name
              column :building_type
              column :location
            end
          end
          tab 'State-wide Bonuses' do
            panel '' do
              attributes_table_for s.building_bonuses do
                Statistic::TYPES.each do |stat|
                  row stat
                end
              end
            end
          end
        end
      end
      tab 'Upkeep' do
        panel 'Stability' do
          attributes_table_for s.stability_tab do
            row :effective_stability
            row :control_dc
            row :success_chance
            row :on_success
            row :on_failure
          end
        end

        panel 'Consumption' do
          attributes_table_for s.consumption_tab do
            row :consumption
            row :money_left
            row :effects
          end
        end

        panel 'Unrest' do
          attributes_table_for s.upkeep_unrest_tab do
            keys = s.upkeep_unrest_tab.keys
            if keys.empty?
              row 'Effects' do
                'None'
              end
            else
              keys.each do |key|
                row key
              end
              end
          end
        end
      end
      tab 'Income' do
        panel 'Taxes' do
          attributes_table_for s.income_taxes_tab do
            row :low_estimate
            row :average
            row :high_estimate
          end
        end
      end
      tab 'Subjects' do
        table_for s.subjects do
          column :name do |ss|
            link_to ss.name, [:admin, ss]
          end
        end
      end
      tab 'Geometry' do
        attributes_table do
          row :geometry
          row :realm_geometry
        end
      end
    end
  end
end
