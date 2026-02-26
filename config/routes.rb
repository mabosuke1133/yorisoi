Rails.application.routes.draw do
  namespace :admin do
    get 'posts/index'
    get 'posts/show'
  end
  namespace :admin do
    resources :users, only: [:index, :show, :destroy]
    # 💡 管理者は投稿の一覧・詳細・削除ができる
    resources :posts, only: [:index, :show, :destroy] do
      # 💡 管理者は投稿に紐付くコメントを削除できる
      resources :post_comments, only: [:destroy]
  end

  get 'searches/search'
  root to: 'homes#top'
  get 'about' => 'homes#about'
  
  devise_for :users
  devise_for :admins

  get '/users' => redirect('/users/sign_up')

  resources :users, only: [:show, :destroy] 

  resources :posts do
    # コメントは投稿に紐付くため、中に書く（ネスト）
    resources :post_comments, only: [:create, :destroy]
    
    # 元々あった確認画面もここに入れるとスッキリする
    member do
      get 'confirm'
    end
  end

  get "search" => "searches#search"
end