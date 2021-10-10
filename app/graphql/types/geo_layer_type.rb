module Types
  class GeoLayerType < Types::BaseObject
    field :id, ID, null: false
    field :world_id, Integer, null: false
    field :x, Integer, null: true
    field :y, Integer, null: true
    field :parent_id, Integer, null: false
    field :parent_type, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :title, String, null: true
    field :geometry, String, null: true
  end
end
