Rails.application.routes.draw do
  match 'countries/random', to: 'countries#random', via: [:get]
  resources :countries, :only => [:index, :show]
  root to: redirect('/countries')
end
