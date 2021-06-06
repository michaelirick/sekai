ActiveAdmin.register World do
  menu parent: 'geography', priority: 7

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  show do |w|
    attributes_table do
      row :name
      row :created_at
    end

    tabs do
      tab 'Continents' do
        table_for w.continents do
          column :id
          column :name
        end
      end
      tab 'Map' do
        react_component 'Map/index', { world: w }
      end
    end
  end

end
