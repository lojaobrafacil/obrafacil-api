Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  	namespace :api, default: { format: [:json, :'form-data'] }, constraints: { subdomain: 'api' }, path: '/' do
      namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
        mount_devise_token_auth_for 'User', at: 'auth'
        resources :users, only: [:index, :show, :update]
        put 'reset_password', to: :reset_password, controller: 'users'
        resources :address_types, only: [:index, :show, :create, :update, :destroy]
        resources :email_types, only: [:index, :show, :create, :update, :destroy]
        resources :phone_types, only: [:index, :show, :create, :update, :destroy]
        resources :cities, only: [:index, :show, :create, :update, :destroy]
        resources :regions, only: [:index, :show, :create, :update, :destroy]
        resources :states, only: [:index, :show, :create, :update, :destroy]
        resources :addresses, only: [:index, :show, :update, :destroy]
        resources :emails, only: [:index, :show, :update, :create, :destroy]
        resources :phones, only: [:index, :show, :update, :create, :destroy]
        resources :billing_types, only: [:index, :show, :create, :update, :destroy]
        resources :banks, only: [:index, :show, :create, :update, :destroy]
        resources :clients, only: [:index, :show, :create, :update, :destroy]
        resources :partners, only: [:index, :show, :create, :update, :destroy]
        resources :companies, only: [:index, :show, :create, :update, :destroy]
        resources :suppliers, only: [:index, :show, :create, :update, :destroy]
        resources :permissions, only: [:index, :show, :create, :update, :destroy]
        resources :employees, only: [:index, :show, :create, :update, :destroy]
        resources :categories, only: [:index, :show, :create, :update, :destroy]
        resources :sub_categories, only: [:index, :show, :create, :update, :destroy]
        resources :units, only: [:index, :show, :create, :update, :destroy]
        resources :products, only: [:index, :show, :create, :update, :destroy]
        resources :price_percentages, only: [:index, :show, :create, :update, :destroy]
        resources :carriers, only: [:index, :show, :create, :update, :destroy]
        resources :ibpts, only: [:index, :show, :create, :update, :destroy]
        resources :cfops, only: [:index, :show, :create, :update, :destroy]
        resources :payment_methods, only: [:index, :show, :create, :update, :destroy]
        resources :cashiers, only: [:index, :show, :create, :update, :destroy]
        resources :orders, only: [:index, :show, :create, :update, :destroy]
        resources :vehicles, only: [:index, :show, :create, :update, :destroy]
        resources :commissions, only: [:index, :create, :update, :destroy]
        resources :images, only: [:create, :destroy]
        resources :reports, only: [:index]
        get 'allbanks', to: :allbanks, controller: 'banks'
  		end
  	end

end
