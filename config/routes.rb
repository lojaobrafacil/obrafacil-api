Rails.application.routes.draw do
  require "sidekiq/web"

  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Api::Engine => "/docs"
  mount Rswag::Ui::Engine => "/docs"

  get "version" => "application#version"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json }, constraints: { subdomain: Rails.env.staging? ? "hubco" : "api" }, path: "/" do
    mount_devise_token_auth_for "Employee", at: "auth"
    as :employee do
      resources :employees
    end
    resources :users, only: [:index, :show, :update]
    resources :addresses
    resources :address_types
    resources :emails
    resources :email_types
    resources :phones
    resources :phone_types
    resources :cities
    resources :regions
    resources :states
    resources :billing_types
    resources :banks
    resources :clients
    resources :partners
    resources :partner_groups
    resources :companies
    resources :suppliers
    resources :permissions
    resources :categories
    resources :sub_categories
    resources :units
    resources :products
    resources :price_percentages
    resources :carriers
    resources :ibpts
    resources :cfops
    resources :payment_methods
    resources :cashiers
    resources :orders
    resources :vehicles
    resources :commissions, only: [:index, :create, :update, :destroy] do
      collection do
        get "by_year/:partner_id/:year", to: "commissions#by_year"
        get "consolidated_by_year/:year", to: "commissions#consolidated_by_year"
        get "create_many", to: "commissions#create_many"
      end
    end
    resources :images, only: [:create, :destroy]
    resources :reports, only: [:index, :create]
    resources :apis
    resources :company_products, only: [:index, :show, :update]

    resources :pi_vouchers do
      collection do
        post ":id/send_email", to: "pi_vouchers#send_email"
        put ":id/used", to: "pi_vouchers#used"
        put ":id/inactivate", to: "pi_vouchers#inactivate"
        put ":id/received", to: "pi_vouchers#received"
      end
    end

    put "products/:product_id/company_products", to: "company_products#update_code_by_product"

    namespace :log do
      resources :premio_ideals, only: [:index, :show]
      put "premio_ideals/:id/retry", to: "premio_ideals#retry"
    end

    put "partners/:id/reset_password", to: "partners#reset_password"
    put "change_employee_password/:id", to: "employees#change_employee_password"
    get "allbanks", to: :allbanks, controller: "banks"
    delete "commissions/destroy_all/:partner_id", to: "commissions#destroy_all"

    namespace :partner do
      mount_devise_token_auth_for "User", at: "auth"
      put "reset_password", to: :reset_password, controller: "users"
      resources :partners, only: [:index]
      resources :commissions, only: [:index]
    end

    namespace :client do
      mount_devise_token_auth_for "User", at: "auth"
      put "reset_password", to: :reset_password, controller: "users"
      resources :address_types, only: [:index, :show]
      resources :email_types, only: [:index, :show]
      resources :phone_types, only: [:index, :show]
      resources :cities, only: [:index, :show]
      resources :regions, only: [:index, :show]
      resources :states, only: [:index, :show]
      resources :clients, only: [:show, :update]
      get "allbanks", to: :allbanks, controller: "banks"
    end
  end
end
