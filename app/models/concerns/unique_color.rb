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

  module ClassMethods

  end
end
