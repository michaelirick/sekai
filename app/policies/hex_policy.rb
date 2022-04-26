class HexPolicy < GeoLayerPolicy
  def update_boundaries?
    admin?
  end

  def pages?
    index?
  end

  class Scope < Scope
    def resolve
      scope.all.for_world(@user.selected_world)
    end
  end
end
