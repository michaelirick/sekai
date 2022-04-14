ActiveAdmin.register Settlement do
  menu if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :owner_id, :hex_id, :world_id, :population
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
      f.input :owner_id, as: :select, collection: State.for_world(current_user.selected_world)
      f.input :hex_id, as: :select, collection: Hex.for_world(current_user.selected_world)
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
      f.input :population
    end
    f.actions
  end

  show do |s|
    attributes_table do
      row :name
      row :settlement_type do |s|
        s.settlement_type.to_s.titleize
      end
      row :hex
      row :owner
      row :population_capacity
      row :population
      row :base_value
      row :control_dc
    end

    tabs do
      tab 'Modifiers' do
        panel '' do
          attributes_table_for s.modifiers do
            Settlement::TYPE_MODIFIERS.each do |stat|
              row stat
            end
          end
        end
      end
      tab 'Buildings' do
        tabs do
          tab 'Buildings' do
            table_for s.buildings do
              column :name
              column :building_type
            end
          end
          tab 'Settlement Bonuses' do
            attributes_table_for settlement.building_bonuses do
              Statistic::TYPES.each do |stat|
                row stat
              end
            end
          end
        end
      end
    end
  end
end
