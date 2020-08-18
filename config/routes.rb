Rails.application.routes.draw do
  root 'books#index'

  match '/success', to: 'books#success', via: :get
  resources :books do
    member do
      get :more
    end
  end
end
