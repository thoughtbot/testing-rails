Rails.application.routes.draw do
  resources :links, only: [:show, :new, :create] do
    resource :upvote, only: [:create]
    resource :downvote, only: [:create]
  end

  root to: "links#index"
end
