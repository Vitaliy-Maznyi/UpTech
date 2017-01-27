Rails.application.routes.draw do

  use_doorkeeper

  devise_for :users,
  only: :registrations, controllers: { registrations: 'registrations' }

  root to: 'api/v1/events#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :events, except: [:new, :edit] do
        resources :comments, only: [:create, :destroy]
        post 'invite/:id' => 'participants#create'
        delete 'expel/:id' => 'participants#destroy'
      end
      get 'feed' => 'activities#index'
    end
  end

end
