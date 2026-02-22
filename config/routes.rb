Rails.application.routes.draw do
  root to: 'homes#top'
  get 'about' => 'homes#about'

  devise_for :admins
  devise_for :users

  resources :users, only: [:show, :edit, :update]

  # 1. resources を先に書く（これで /posts/new が正しく判定されます）
  resources :posts

  # 2. その後に、今回の「確認」と「削除」のカスタムルートを書く
  get 'posts/:id/confirm' => 'posts#confirm', as: 'confirm_post'
  get 'posts/:id/sakujo' => 'posts#destroy', as: 'destroy_post'
end