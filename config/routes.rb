Rails.application.routes.draw do
  resources :countries, :only => [:index, :show]
  root to: redirect('/countries')
end
