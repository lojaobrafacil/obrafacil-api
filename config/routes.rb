Rails.application.routes.draw do
  root "welcomes#index"
  require "sidekiq/web"

  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Api::Engine => "/docs"
  mount Rswag::Ui::Engine => "/docs"

  get "version" => "application#version"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json }, constraints: { subdomain: Rails.env.staging? ? "hubco" : "api" }, path: "/" do
    mount_devise_token_auth_for "Employee", at: "auth", skip: [:registrations]
    as :employee do
      resources :employees do
        collection do
          put ":id/password", to: "employees#password"
        end
      end
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
    resources :partners do
      collection do
        put ":id/reset_password", to: "partners#reset_password"
        post "send_sms/:status", to: "partners#send_sms", constraints: { status: /active|pre_active|transfer_points|workshop/ }
      end
    end
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

    resources :pi_vouchers, except: [:update, :destroy] do
      collection do
        get "by_status/:status", to: "pi_vouchers#by_status", constraints: { status: /not_used|used_not_received|used_received/ }
        post ":id/send_email", to: "pi_vouchers#send_email"
        put ":id/:status", to: "pi_vouchers#update", constraints: { status: /used|inactivate|received/ }
      end
    end

    put "products/:product_id/company_products", to: "company_products#update_code_by_product"

    namespace :log do
      resources :premio_ideals, only: [:index, :show]
      put "premio_ideals/:id/retry", to: "premio_ideals#retry"
      resources :workers, only: [:index, :show]
    end
    get "allbanks", to: :allbanks, controller: "banks"
    delete "commissions/destroy_all/:partner_id", to: "commissions#destroy_all"

    get "zipcodes/:code", to: "zipcodes#by_code", constraints: { code: /[0-9|]+/ }
  end

  namespace :partner, defaults: { format: :json }, constraints: { subdomain: "partner" }, path: "/" do
    mount_devise_token_auth_for "User", at: "auth", skip: [:registrations]
    put "selfs/password", to: "selfs#update_password"
    resources :selfs, only: [:index, :create]
    resources :commissions, only: [:index]
    resources :banks, only: [:index]
    get "zipcodes/:code", to: "zipcodes#by_code", constraints: { code: /[0-9|]+/ }
  end
end
