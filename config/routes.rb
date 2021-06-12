Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  namespace :admin do
    get 'worlds/:id/map', to: 'worlds#map'
  end
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
