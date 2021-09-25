class AddStartDateIdToAge < ActiveRecord::Migration[6.1]
  def change
    add_column :ages, :start_date_id, :integer
  end
end
