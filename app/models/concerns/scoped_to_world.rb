module ScopedToWorld
  extend ActiveSupport::Concern

  def factory
    world.factory
  end

  module ClassMethods

  end

  included do
    belongs_to :world
    scope :for_world, -> (world) { where world: world }
  end
end
