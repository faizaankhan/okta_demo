Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'helloworld#index'

  get 'saml/login', to: 'saml#login', as: 'login'
  post 'saml/acs',  to: 'saml#acs'
end
