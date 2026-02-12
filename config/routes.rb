Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/show'
  get 'posts/edit'
  get 'posts/new'
  devise_for :admins
  devise_for :users
  # アプリのトップページ（/）を homesコントローラの topアクションに設定
  root to: 'homes#top' 
  
  # aboutページのURLを /about に設定
  get 'about' => 'homes#about'

  resources :posts
  
end
