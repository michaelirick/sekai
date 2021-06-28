class AddSelectedWorldIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :selected_world_id, :integer
  end
end
