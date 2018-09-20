Rails.application.routes.draw do
  require 'sidekiq/web'
 
  Rails.application.routes.draw do
    mount Sidekiq::Web => '/sidekiq'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, default: { format: [:json, :'form-data'] }, constraints: { subdomain: 'api' }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :employees, only: [:index, :show, :create, :update, :destroy]
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
  
    namespace :v2, path: '/', constraints: ApiVersionConstraint.new(version: 2) do
      namespace :admin do
        mount_devise_token_auth_for 'Employee', at: 'auth'
        as :employee do
          resources :employees, only: [:index, :show, :create, :update, :destroy]
        end
        resources :users, only: [:index, :show, :update]
        resources :address_types, only: [:index, :show, :create, :update, :destroy]
        resources :email_types, only: [:index, :show, :create, :update, :destroy]
        resources :phone_types, only: [:index, :show, :create, :update, :destroy]
        resources :cities, only: [:index, :show, :create, :update, :destroy]
        resources :regions, only: [:index, :show, :create, :update, :destroy]
        resources :states, only: [:index, :show, :create, :update, :destroy]
        resources :billing_types, only: [:index, :show, :create, :update, :destroy]
        resources :banks, only: [:index, :show, :create, :update, :destroy]
        resources :clients, only: [:index, :show, :create, :update, :destroy]
        resources :partners, only: [:index, :show, :create, :update, :destroy]
        resources :companies, only: [:index, :show, :create, :update, :destroy]
        resources :suppliers, only: [:index, :show, :create, :update, :destroy]
        resources :permissions, only: [:index, :show, :create, :update, :destroy]
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
        
        namespace :log do
          resources :premio_ideals, only: [:index, :show]
          put 'premio_ideals/:id/retry', to: 'premio_ideals#retry'
        end

        put 'reset_password', to: :reset_password, controller: 'users'
        put 'change_employee_password/:id', to: 'employees#change_employee_password'
        post 'partners/:id/reset', to: 'partners#reset'
        get 'allbanks', to: :allbanks, controller: 'banks'
        delete 'commissions/destroy_all/:partner_id', to: 'commissions#destroy_all'
      end
      namespace :partner, path: '/' do
        mount_devise_token_auth_for 'User', at: 'auth'
        put 'reset_password', to: :reset_password, controller: 'users'
        resources :address_types, only: [:index, :show]
        resources :email_types, only: [:index, :show]
        resources :phone_types, only: [:index, :show]
        resources :addresses, only: [:index, :show]
        resources :emails, only: [:index, :show]
        resources :phones, only: [:index, :show]
        resources :partners, only: [:show, :update]
        resources :commissions, only: [:index, :create, :update, :destroy]
        get 'allbanks', to: :allbanks, controller: 'banks'
      end
      namespace :clients do
        mount_devise_token_auth_for 'User', at: 'auth'
        put 'reset_password', to: :reset_password, controller: 'users'
        resources :address_types, only: [:index, :show]
        resources :email_types, only: [:index, :show]
        resources :phone_types, only: [:index, :show]
        resources :cities, only: [:index, :show]
        resources :regions, only: [:index, :show]
        resources :states, only: [:index, :show]
        resources :addresses, only: [:index, :show]
        resources :emails, only: [:index, :show]
        resources :phones, only: [:index, :show]
        resources :clients, only: [:show, :update]
        get 'allbanks', to: :allbanks, controller: 'banks'
      end
    end
  end

end
