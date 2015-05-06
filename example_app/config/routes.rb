Rails.application.routes.draw do
  resources :links, only: [:show, :new, :create] do
    resource :upvote, only: [:create]
    resource :downvote, only: [:create]
  end

  get "/new", to: "new_links#index", as: "new_links"

  root to: "links#index"
end
