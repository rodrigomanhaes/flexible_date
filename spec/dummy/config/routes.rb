Dummy::Application.routes.draw do
  resources :events, except: [:index, :delete]
end
