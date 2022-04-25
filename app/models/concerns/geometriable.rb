module Geometriable
  extend ActiveSupport::Concern

  def after_geometry_reset; end

  def new_geometry_query
    'you need to override this'
  end

  def reset_geometry!
    new_geometry = GeoLayer.connection.execute(new_geometry_query).map(&:to_h).first['new_geometry']
    new_geometry = RGeo::GeoJSON.decode new_geometry
    self.geometry = factory.collection [new_geometry].compact
    self.save!
    after_geometry_reset
  rescue => e
    puts "State #{id} #{name} failed to reset geometry:"
    puts e.full_message
  end

  module ClassMethods

  end
end
