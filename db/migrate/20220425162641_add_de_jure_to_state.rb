class AddDeJureToState < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :de_jure_id, :integer
    add_column :states, :de_jure_type, :string
  end
end
