Rails.application.routes.draw do
  devise_for :users, only: [:sessions], controllers: { sessions: 'api/v1/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  	namespace :api, default: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
  		namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
  			resources :users, only: [:show, :create, :update, :destroy]
        resources :sessions, only: [:create, :destroy]
        resources :address_types, only: [:index, :show, :create, :update, :destroy]
        resources :email_types, only: [:index, :show, :create, :update, :destroy]
        resources :phone_types, only: [:index, :show, :create, :update, :destroy]
        resources :cities, only: [:index, :show, :create, :update, :destroy]
        resources :regions, only: [:index, :show, :create, :update, :destroy]
        resources :states, only: [:index, :show, :create, :update, :destroy]
        resources :addresses, only: [:index, :show, :update, :destroy]
        resources :emails, only: [:index, :show, :update, :destroy]
        resources :phones, only: [:index, :show, :update, :destroy]
        resources :billing_types, only: [:index, :show, :create, :update, :destroy]
        resources :banks, only: [:index, :show, :create, :update, :destroy]
        resources :clients, only: [:index, :show, :create, :update, :destroy]
        resources :partners, only: [:index, :show, :create, :update, :destroy]
        resources :companies, only: [:index, :show, :create, :update, :destroy]
        resources :providers, only: [:index, :show, :create, :update, :destroy]
        resources :permissions, only: [:index, :show, :create, :update, :destroy]
  		end
  	end

end
