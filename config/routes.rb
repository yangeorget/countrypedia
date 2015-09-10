Rails.application.routes.draw do
  resources :countries, :only => [:index, :show]
end
