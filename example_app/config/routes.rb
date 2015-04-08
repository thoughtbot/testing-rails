Rails.application.routes.draw do
  resources :links, only: [:show, :new, :create]

  root to: "links#index"
end
