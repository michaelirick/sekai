class AddUserIdToWorld < ActiveRecord::Migration[6.1]
  def change
    add_column :worlds, :user_id, :integer
  end
end
