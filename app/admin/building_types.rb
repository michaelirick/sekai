ActiveAdmin.register BuildingType do
  menu parent: 'Misc'
  permit_params *%i[
    name
    slug
    upgrade_id
    lots
    cost
    faction_bonus
    settlement_bonus
    flags
    limits
    need_types
    output_types
    effects
    discounts
  ]

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :lots
    column :cost
    actions
  end

  filter :name
  filter :slug
  filter :lots
  filter :cost


  form do |f|
    f.inputs do
      f.input :name
      f.input :slug
      f.input :lots
      f.input :cost
      f.input :faction_bonus, as: :text, input_html: { class: 'jsoneditor-target' }
      f.input :settlement_bonus, as: :text, input_html: { class: 'jsoneditor-target' }
      f.input :upgrade, collection: BuildingType.all
    end
    f.actions
  end

end
