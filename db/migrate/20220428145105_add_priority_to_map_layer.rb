class AddPriorityToMapLayer < ActiveRecord::Migration[6.1]
  def change
    add_column :map_layers, :priority, :integer
  end
end
