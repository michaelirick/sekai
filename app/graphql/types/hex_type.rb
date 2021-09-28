module Types
  class HexType < Types::BaseObject
    field :id, ID, null: false
    field :world_id, Integer, null: true
    field :x, Integer, null: true
    field :y, Integer, null: true
    field :owner_id, Integer, null: true
    field :province_id, Integer, null: true
    field :terrain_type, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :title, String, null: true
  end
end
