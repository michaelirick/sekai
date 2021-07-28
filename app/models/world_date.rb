class WorldDate < ApplicationRecord
  belongs_to :age
  scope :for_world, ->(w) do
    joins(age: :world).where(ages: {world: w})
  end

  def title
    "#{year} #{age.abbreviation}/#{month}/#{day}"
  end
end
