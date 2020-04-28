Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
}

  resources :tweets

  # Routes for forgot password
  post 'password/forgot', to: 'passwords#forgot'
  post 'password/reset', to: 'passwords#reset'
end
