class Hex < ApplicationRecord
  resourcify
  belongs_to :province
  belongs_to :owner, class_name: 'State', optional: true
  belongs_to :world

  scope :for_world, -> (w) { where(world_id: w) }

  scope :viewable_on_map_at, -> (world, x, y, zoom) do
    return where('1=2') if zoom < 2
    hexes = where(world: world)
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
