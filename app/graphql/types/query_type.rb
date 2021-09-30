module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :hex, [Types::HexType], null: false, description: 'test' do
      argument :world_id, Integer, required: true
      argument :x, Integer, required: false
      argument :y, Integer, required: false
      argument :zoom, Integer, required: false
    end

    def hex(args)
      puts 'get them hexes'
      # hexes = Hex.all
      hexes = Hex.where(world_id: args[:world_id])
      radius = args[:zoom] * 5
      
      hexes = hexes.where(x: ((args[:x] - radius)..(args[:x] + radius))) if args[:x]
      hexes = hexes.where(y: ((args[:y] - radius)..(args[:y] + radius))) if args[:y]
      hexes
    end
  end
end
