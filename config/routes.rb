Rails.application.routes.draw do
  root "welcomes#index"
  require "sidekiq/web"
  require "sidekiq-scheduler/web"

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "devuser" && password == "nopassword"
  end

  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Api::Engine => "/docs"
  mount Rswag::Ui::Engine => "/docs"

  get "version" => "application#version"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json }, constraints: { subdomain: Rails.env.staging? ? "api-stg" : "api" }, path: "/" do
    mount_devise_token_auth_for "Employee", at: "auth", skip: [:registrations]
    as :employee do
      resources :employees do
        collection do
          put ":id/reset_password", to: "employees#reset_password"
          put ":id/password", to: "employees#password"
        end
      end
    end
    resources :addresses
    resources :address_types
    resources :emails
    resources :email_types
    resources :phones
    resources :phone_types
    resources :coupons do
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
        get "by_federal_registration/:federal_registration", to: "partners#by_federal_registration"
        get "by_favored_federal_registration/:favored_federal_registration", to: "partners#by_favored_federal_registration"
      end
    end
    resources :partner_groups
    resources :partner_projects do
      collection do
        get ":id/images", to: "partner_projects#images"
        put ":id/images", to: "partner_projects#images_position"
      end
    end
    resources :project_images
    resources :companies
    resources :suppliers
    resources :permissions
    resources :categories
    resources :sub_categories
    resources :units
    resources :products
    resources :carriers
    resources :ibpts
    resources :cfops
    resources :payment_methods
    resources :scheduled_messages do
      collection do
        post ":id/run", to: "scheduled_messages#run"
      end
    end
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
    resources :stocks, only: [:index, :show, :update]
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
        put ":id", to: "pi_vouchers#update"
        put ":id/:status", to: "pi_vouchers#update", constraints: { status: /use|inactivate|received/ }
      end
    end
    namespace :log do
      resources :premio_ideals, only: [:index, :show]
      put "premio_ideals/:id/retry", to: "premio_ideals#retry"
      resources :workers, only: [:index, :show]
    end
    put "products/:product_id/stocks", to: "stocks#update_code_by_product"
    get "allbanks", to: :allbanks, controller: "banks"
    delete "commissions/destroy_all/:partner_id", to: "commissions#destroy_all"
    get "zipcodes/:code", to: "zipcodes#by_code", constraints: { code: /[0-9|]+/ }
    resources :notifications, only: [:index, :update, :delete] do
      collection do
        put "all", to: "notifications#view_all"
        delete "all", to: "notifications#delete_all"
      end
    end
    resources :dashboard, only: [:index] do
      collection do
        get "all", to: "dashboard#all"
      end
    end
  end

  namespace :api_partner, defaults: { format: :json }, constraints: { subdomain: Rails.env.staging? ? "partner-stg" : "partner" }, path: "/" do
    mount_devise_token_auth_for "Partner", at: "auth", skip: [:registrations], controllers: { sessions: "api_partner/sessions" }
    put "selfs/password", to: "selfs#update_password"
    get "selfs/by_federal_registration/:federal_registration", to: "selfs#by_federal_registration"
    post "forgot_password/:federal_registration", to: "passwords#forgot_password"
    get "validate_to_reset_password/:federal_registration", to: "passwords#validate_to_reset_password"
    post "reset_password", to: "passwords#reset_password"
    resources :selfs, only: [:index, :create]
    resources :commissions, only: [:index]
    resources :banks, only: [:index]
    resources :partners, only: [:index, :show] do
      collection do
        post ":id/send_email", to: "partners#send_email"
      end
    end
    resources :partner_projects
    resources :events, only: [:show]
    get "zipcodes/:code", to: "zipcodes#by_code", constraints: { code: /[0-9|]+/ }
    post "indication", to: "selfs#indication"
    post "contact", to: "base#contact"
    get "web", to: "welcomes#web"
    get "campains", to: "welcomes#campains"
    get "highlights", to: "welcomes#highlights"
    get "highlights/:kind", to: "welcomes#highlights", constraints: { kind: /normal|winner|event/ }
    get "winners", to: "welcomes#winners"
    get "winners/:year", to: "welcomes#winners", constraints: { kind: /[0-9|]+/ }
    get "all", to: "welcomes#all"
  end

  namespace :api_client, defaults: { format: :json }, constraints: { subdomain: Rails.env.staging? ? "client-stg" : "client" }, path: "/" do
    mount_devise_token_auth_for "Client", at: "auth"
    as :client do
      # Define routes for Client within this block.
    end
  end
end
