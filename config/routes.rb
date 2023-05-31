Rails.application.routes.draw do
  require "sidekiq/web"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: "pages#home"
  resources :users, only: %i[show index update]
  resources :interests, only: %i[index show create destroy]
  resources :quizzes, only: %i[index show create new] do
    resources :challenges, only: %i[create new show]
    resources :questions, only: [:show], controller: "quizzes/questions"
  end
  resources :questions

  resources :challenges, only: %i[destroy update]
  authenticate :user, ->(user) { user.admin? } do
    mount Blazer::Engine, at: "blazer"
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end

# questions
# interests/questions -> show

# quizzes/questions -> show
