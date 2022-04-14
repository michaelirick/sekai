ActiveAdmin.register State do
  menu if: proc{true}

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
    :government_type
  )
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :adjective, :world_id, :primary_color, :secondary_color]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  controller do
    before_action :check_for_world

    def check_for_world
      redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :adjective
      f.input :primary_color, as: :color
      f.input :secondary_color, as: :color
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
      f.input :stability
    end
    f.actions
  end

  show do |s|
    attributes_table do
      row :name
      row :adjective
      row :government_type
      row :primary_color
      row :secondary_color
      row :created_at
      row :size do
        s.hexes.count
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
    end
  end
end
