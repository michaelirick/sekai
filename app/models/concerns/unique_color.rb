module UniqueColor
  extend ActiveSupport::Concern

  def ensure_color_generated
    if color.nil? || !has_unique_color?
      generate_color!
    end
  end

  def generate_color!
    range = %w[0 1 2 3 4 5 6 7 8 9 a b c d e f]
    self.color = '#' + 6.times.map { |i| range.sample }.join
    save!
  end

  def has_unique_color?
    raise 'this needs to be implemented'
  end

  def self.generate_color
    range = %w[0 1 2 3 4 5 6 7 8 9 a b c d e f]
    '#' + 6.times.map { |i| range.sample }.join
  end

  def self.allocate_color(world, table, column, n=1, exclude=[])
    # puts table, n, exclude
    colors = n.times.map { UniqueColor.generate_color } - exclude
    unique = colors.uniq
    unique -= ActiveRecord::Base.connection.execute(%(
      SELECT #{column} AS color
      FROM #{table}
      WHERE world_id=#{world.id} AND #{column} IN ('#{unique.join("', '")}')
    )).pluck('color')

    unique += UniqueColor.allocate_color(world, table, column, n - unique.count, unique) if unique.count < n

    unique
  end

  module ClassMethods

  end
end
