class AddUserIdToWorldGenerator < ActiveRecord::Migration[6.1]
  def change
    add_column :world_generators, :user_id, :integer
  end
end
