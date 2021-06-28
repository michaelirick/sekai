class ProvincePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all.for_world(@user.selected_world)
    end
  end
end
