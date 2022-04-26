module Mappable
  def add_reset_geometry!
    member_action :reset_geometry, method: :get do
      format_type = request.format.symbol
      if resource.nil?
        redirect_to resource_path(format: format_type), notice: 'You cannot reset this geometry.'
      else
        begin
          resource.reset_geometry!
          redirect_to resource_path(format: format_type), notice: "You have reset #{resource.title}."
        rescue => e
          redirect_to resource_path(format: format_type), alert: "There was an error"
        end
      end
    end

    action_item :reset_geometry, only: [:show] do
      link_to 'Reset Geometry', send(:"reset_geometry_admin_#{resource.class.to_s.downcase}_path", resource)
    end
  end

  def add_update_boundaries!
    member_action :update_boundaries, method: [:post] do
      resource.update_geometry! params[:points]
      redirect_to resource_path(format: :json)
    end
  end

  def add_pages!
    collection_action :pages do
      collection
      total = collection_before_scope.count
      per_page = params[:per_page].to_i || 10
      page = params[:page].to_i || 1

      render json: {
        per_page: per_page,
        page: page,
        total: total / per_page
      }
    end
  end

  def check_for_world!
    controller do
      before_action :check_for_world

      def check_for_world
        redirect_to :admin_worlds, alert: 'You must first select a world.' unless current_user.selected_world
      end
    end
  end
end
