Rails.application.routes.draw do
  root "welcomes#index"
  require "sidekiq/web"

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "devuser" && password == "nopassword"
  end

  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Api::Engine => "/docs"
  mount Rswag::Ui::Engine => "/docs"

  get "version" => "application#version"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json }, constraints: { subdomain: "api" }, path: "/" do
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
    resources :coupons, except: [:destroy] do
      collection do
        get "by_code/:code", to: "coupons#by_code"
        post "use/:code", to: "coupons#use"
      end
    end
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
        get "by_federal_registration/:federal_registration", to: "partners#by_federal_registration"
        get "by_favored_federal_registration/:favored_federal_registration", to: "partners#by_favored_federal_registration"
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

    resources :highlights do
      collection do
        get ":kind", to: "highlights#index", constraints: { kind: /normal|winner|event/ }
      end
    end

    resources :campains

    resources :pi_vouchers, except: [:update, :destroy] do
      collection do
        get "by_status/:status", to: "pi_vouchers#by_status", constraints: { status: /not_used|used_not_received|used_received/ }
        post ":id/send_email", to: "pi_vouchers#send_email"
        put ":id/:status", to: "pi_vouchers#update", constraints: { status: /use|inactivate|received/ }
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

  namespace :api_partner, defaults: { format: :json }, constraints: { subdomain: "partner" }, path: "/" do
    mount_devise_token_auth_for "Partner", at: "auth", skip: [:registrations], controllers: { sessions: "api_partner/sessions" }
    put "selfs/password", to: "selfs#update_password"
    get "selfs/by_federal_registration/:federal_registration", to: "selfs#by_federal_registration"
    post "forgot_password/:federal_registration", to: "passwords#forgot_password"
    get "validate_to_reset_password/:federal_registration", to: "passwords#validate_to_reset_password"
    post "reset_password", to: "passwords#reset_password"
    resources :selfs, only: [:index, :create]
    resources :commissions, only: [:index]
    resources :banks, only: [:index]
    get "zipcodes/:code", to: "zipcodes#by_code", constraints: { code: /[0-9|]+/ }
    post "indication", to: "selfs#indication"
    get "web", to: "welcomes#web"
    get "campains", to: "welcomes#campains"
    get "highlights", to: "welcomes#highlights"
    get "highlights/:kind", to: "welcomes#highlights", constraints: { kind: /normal|winner|event/ }
  end

  namespace :api_client, defaults: { format: :json }, constraints: { subdomain: "client" }, path: "/" do
    mount_devise_token_auth_for "Client", at: "auth"
    as :client do
      # Define routes for Client within this block.
    end
  end
end
