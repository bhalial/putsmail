Putsmail::Application.routes.draw do
  resources :galleries, only: [:index, :show]

  post "subscription_listener/subscribe"
  post "subscription_listener/unsubscribe"

  get "site/index"

  root :to => "site#index"

  namespace :api do
    put "/add_to_gallery"      , to: "test_mails#add_to_gallery"
    resources :test_mails      , only: [:create, :show, :update, :destroy]
    resources :test_mail_users , except: [:edit]
    resources :check_htmls     , only: [:create]
  end

  namespace :pro do
    match "auth/:provider/callback", to: "sessions#create"
    match "auth/failure", to: redirect("/")
    match "signout", to: "sessions#destroy", as: "signout"
    get "tests", to: "test_mails#index"
  end

  get "/test_mails/:id" , to: "site#old_gallery_item"
  get "/gallery"        , to: "site#old_gallery"
  get "/tests/:token"   , to: "site#index"
  get "/:token"         , to: "site#old_index"
end
