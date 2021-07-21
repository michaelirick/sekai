class Hexes::Index < ApplicationRepresentor
  def attributes
    %i[id title x y owner_id province_id terrain_type color]
  end

  def color
    'red'
  end
end