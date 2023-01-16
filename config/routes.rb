Rails.application.routes.draw do

  devise_for :users
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'home/index'

  resources :appointments do
    get :find_appointment, on: :collection
    delete :cancel_appointment, on: :member
  end

  resources :availabilities
end
