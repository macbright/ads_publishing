Rails.application.routes.draw do
 
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  namespace :api, defaults: {format: :json} do
    namespace :v1 do 
      devise_scope :user do
        get    '/users/current'  => 'users#current'
        delete '/users/:id'       => 'users#destroy'
        delete 'sign_out'       => 'sessions#destroy'
        get   "users/:id(:format)", to: "users#show"
        patch  "users/:id", to: "users#user_to_admin"
        patch  "users/:id", to: "users#update"
        get   "users/", to: "users#index"
        post "sign_up", to: "users#create"
        post "sign_in", to: "sessions#create"
      end
    end
  end
end
