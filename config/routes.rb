Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  
  post 'login', to: 'access_tokens#create'
  
  # 现在暂时只需要index
  resources :articles, only: [:index, :show]
end
