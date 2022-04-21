class GeoLayerPolicy < ApplicationPolicy
  def reset_geometry?
    admin?
  end

  def show?
    @record.world == @user.selected_world
  end

  class Scope < Scope
    def resolve
      scope.all.for_world(@user.selected_world)
    end
  end
end
