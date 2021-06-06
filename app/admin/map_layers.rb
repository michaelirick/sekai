ActiveAdmin.register MapLayer do
  menu parent: 'geography', priority: 100

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :world_id, :image, :world
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :world_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  form do |f|
    input :title
    input :world, as: :select
    input :image, as: :file

    actions
  end

  show do |m|
    attributes_table do
      row :title
      row :world
      row :created_at
      row :updated_at
      row :image do |ad|
        image_tag url_for(ad.image)
      end
    end
  end
end
