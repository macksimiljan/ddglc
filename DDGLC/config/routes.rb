Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'home/index'

  namespace :project do
    get '/about',   to: 'about#index'
    get '/staff',   to: 'staff#index'
    get '/contact', to: 'contact#index'
    get '/imprint', to: 'imprint#index'
  end

  namespace :lexicon do
    get '/about', to: 'about#index'
    get '/', to: 'about#index'
  end

  resources :lemmas, path: '/lexicon/lemmas'
  resources :lemma_comments, path: '/lexicon/lemma_comments'
  resources :sublemmas, path: '/lexicon/sublemmas'
  resources :sublemma_comments, path: '/lexicon/sublemma_comments'
  resources :usages, path: '/lexicon/usages'
  resources :usage_comments, path: '/lexicon/usage_comments'

  resources :part_of_speeches, path: 'lexicon/pos'
  resources :languages, path: '/lexicon/languages'
  resources :semantic_fields, path: '/lexicon/semantic_fields'
  resources :usage_categories, path: '/lexicon/usage_categories'
  resources :distinction_tiers, path: '/lexicon/distinction_tiers'

  resources :users

  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get  '/logout', to: 'sessions#destroy'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
