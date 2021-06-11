class Hex < ApplicationRecord
  belongs_to :province
  belongs_to :owner, class_name: 'State', optional: true

  scope :viewable_on_map_at, -> (x, y, zoom) do
    hexes = self
    range = 100
    {x: x, y: y}.each do |c, v| # coord, value
      [-1, 1].each do |m| # multiple
        d = (m * range * (1.0/zoom))
        bound = v + d
        hexes = hexes.where(
          "#{c} #{m.positive? ? '<' : '>'} ?",
          bound
        )
      end
    end

    hexes
  end
end
