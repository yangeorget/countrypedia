Rails.application.routes.draw do
  match 'countries/random', to: 'countries#random', via: [:get]
  match 'cities/random', to: 'cities#random', via: [:get]
  resources :countries, :only => [:index, :show] do
      resources :cities, :only => [:index, :show]
  end
  get "/pages/:page" => "pages#show"
  get "/cities" => "cities#index"
  root to: redirect('/countries')
end
