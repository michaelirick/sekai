class HexPolicy < ApplicationPolicy
  def update_boundaries?
    admin?
  end

  class Scope < Scope
    def resolve
      scope.all.for_world(@user.selected_world)
    end
  end
end
