ActiveAdmin.register Building do
  menu parent: 'locations'
  permit_params *%i[
    name building_type building_type_id location_id location_type owner_id owner_type completion_date world_id
  ]

  index do
    selectable_column
    id_column
    column :name
    column :building_type
    column :location
    column :owner

    actions
  end

  filter :name
  filter :building_type
  filter :completion_date

  form do |f|
    f.inputs do
      f.input :name
      f.input :building_type
      f.input :owner, collection: State.for_world(current_user.selected_world.id)
      f.input :owner_type, as: :hidden, input_html: {value: 'State'}
      f.input :location, collection: Hex.for_world(current_user.selected_world.id)
      f.input :location_type, as: :hidden, input_html: {value: 'GeoLayer'}
      f.input :completion_date
      f.input :world_id, as: :hidden, input_html: {value: current_user.selected_world.id}
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :building_type
      row :owner
      row :flags
      row :location
      row :created_at
    end

    tabs do
      tab 'Settlement Bonus' do
        attributes_table_for building.settlement_bonus do
          Statistic::TYPES.each do |stat|
            row stat
          end
        end
      end
      tab 'Faction Bonus' do
        attributes_table_for building.faction_bonus do
          Statistic::TYPES.each do |stat|
            row stat
          end
        end
      end
    end

  end

  controller do
    before_action :check_for_world

    def check_for_world
      redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
    end
  end
end
