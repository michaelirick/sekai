ActiveAdmin.register State do
  menu if: proc{true}

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :adjective, :world_id, :primary_color, :secondary_color
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
    end
    f.actions
  end

  show do |s|
    attributes_table do
      row :name
      row :adjective
      row :primary_color
      row :secondary_color
      row :created_at
    end

    tabs do
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
            table_for s.building_bonuses
          end
        end
      end
    end
  end
end
