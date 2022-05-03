class StatePolicy < ApplicationPolicy
  def reset_geometry?
    admin?
  end

  def reset_de_jure?
    admin?
  end

  def claim?
    admin?
  end

  class Scope < Scope
    def resolve
      scope.all.for_world(@user.selected_world)
    end
  end
end
