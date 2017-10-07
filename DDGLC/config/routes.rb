Rails.application.routes.draw do
  get 'home/index'

  namespace :project do
    get '/about',   to: 'about#index'
    get '/staff',   to: 'staff#index'
    get '/contact', to: 'contact#index'
    get '/imprint', to: 'imprint#index'
  end

  namespace :lexicon do
    get '/about', to: 'about#index'
  end

  resources :lemmas, path: '/lexicon/lemmas'
  resources :sublemmas, path: '/lexicon/sublemmas'
  resources :usages, path: '/lexicon/usages'
  resources :part_of_speeches, path: 'lexicon/pos'
  resources :languages, path: '/lexicon/languages'


  resources :users

  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  get  '/logout', to: 'sessions#destroy'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
