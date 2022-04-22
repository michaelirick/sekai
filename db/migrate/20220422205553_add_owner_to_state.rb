class AddOwnerToState < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :owner_id, :integer
    add_column :states, :owner_type, :string
  end
end
