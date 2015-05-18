Rails.application.routes.draw do
  resources :links, only: [:show, :new, :create] do
    resource :upvote, only: [:create]
    resource :downvote, only: [:create]
  end

  namespace :api do
    namespace :v1 do
      resources :links, only: [:index, :create]
    end
  end

  get "/new", to: "new_links#index", as: "new_links"

  root to: "links#index"
end
