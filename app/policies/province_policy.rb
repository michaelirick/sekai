class ProvincePolicy < GeoLayerPolicy
  def reset_geometry?
    admin?
  end
  class Scope < Scope
    def resolve
      scope.all.for_world(@user.selected_world)
    end
  end
end
