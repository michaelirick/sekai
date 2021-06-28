class WorldPolicy < ApplicationPolicy
  def map?
    admin?
  end

  def select_world?
    admin?
  end

  class Scope < Scope
    def resolve
      scope.where(user: @user)
    end
  end
end
