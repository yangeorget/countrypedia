Rails.application.routes.draw do
  resources :languages, :only => [:index, :show] do
    resources :countries, :only => [:show]
  end

  root to: "languages#index"
end
