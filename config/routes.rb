Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :secret_messages, only: [:show]
    end
  end
end
