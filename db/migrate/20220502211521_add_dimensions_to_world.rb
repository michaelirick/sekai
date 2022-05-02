class AddDimensionsToWorld < ActiveRecord::Migration[6.1]
  def change
    add_column :worlds, :resolution_x, :integer
    add_column :worlds, :resolution_y, :integer
    add_column :worlds, :circumference, :integer
  end
end
