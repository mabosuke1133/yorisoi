Rails.application.routes.draw do
  root to: 'homes#top'
  get 'about' => 'homes#about'
  
  devise_for :users
  devise_for :admins

  get '/users' => redirect('/users/sign_up')

  resources :users, only: [:show, :destroy] 

  resources :posts
  get 'posts/:id/confirm' => 'posts#confirm', as: 'confirm_post'

  # postsの削除はDELETEで実装することをおすすめします
  # resources :posts, only: [:destroy] などを使うのが良いです

  # get 'posts/:id/sakujo' => 'posts#destroy', as: 'destroy_post' # これは非推奨
end