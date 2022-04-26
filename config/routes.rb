Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  devise_for :users, ActiveAdmin::Devise.config

  namespace :admin do
    get 'worlds/:id/map', to: 'worlds#map'
    get 'hexes/biomes', to: 'hexes#biomes'
    get 'hexes/terrains', to: 'hexes#terrains'
    # get 'hexes/pages', to: 'hexes#pages'
  end
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
