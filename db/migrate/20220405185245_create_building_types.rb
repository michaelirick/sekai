class CreateBuildingTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :building_types do |t|
      t.string :name
      t.string :slug
      t.integer :upgrade_id
      t.integer :lots
      t.integer :cost
      t.jsonb :faction_bonus, default: {}
      t.jsonb :settlement_bonus, default: {}
      t.string :flags
      t.jsonb :limits, default: {}
      t.jsonb :need_types, default: {}
      t.jsonb :output_types, default: {}
      t.jsonb :effects, default: {}
      t.jsonb :discounts, default: {}

      t.timestamps
    end
  end
end
