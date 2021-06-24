class AddTitleToHex < ActiveRecord::Migration[6.1]
  def change
    add_column :hexes, :title, :string
  end
end
