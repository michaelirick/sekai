module GeoLayerable
  extend ActiveSupport::Concern

  class_methods do
    def add_geo_layer(options={})
      @geo_subordinates = options[:subordinates] if options[:subordinates]
      @geo_parent = options[:parent] if options[:parent]
      @geo_name = options[:name] if options[:name]
    end

    def geo_subordinates
      @geo_subordinates
    end

    def geo_parent
      @geo_parent
    end

    def geo_name
      @geo_name
    end
  end

  included do
    def geo_subordinates
      send self.class.geo_subordinates
    end

    def geo_parent
      send self.class.geo_parent
    end

    def geo_name
      send self.class.geo_name
    end



    def to_shape
      shapes = geo_subordinates.map(&:to_shape)

      shapes.reduce do |memo, current|
        memo.union current
      rescue => lol
        retry
      end
    end

    def to_points
      if cached_points
        return cached_points
      end

      shape = to_shape
# binding.pry
      self.cached_points = shape.points.map do |p|
        [p.x, p.y]
      end

      save

      cached_points
    end
  end
end