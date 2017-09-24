Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :secret_messages, only: [:index, :show]
    end
  end
end
