Rails.application.routes.draw do
  get 'favorites/index'
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
  end

  root to: 'homes#top'
  get 'searches/search'
  get "search" => "searches#search"
  get 'about' => 'homes#about'
  
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    registrations: 'admins/registrations',
    passwords:     'admins/passwords'
  }

  get '/users' => redirect('/users/sign_up')

  resources :users, only: [:show, :destroy] 

  resources :posts do
    # コメントは投稿に紐付くため、中に書く（ネスト）
    resources :post_comments, only: [:create, :destroy]

    # --- 💡 1. いいね機能を追加 (ネストさせる) ---
    # 単数形の resource にすることで「一人が一つの投稿に一回だけいいね」という構造になります
    resource :favorites, only: [:create, :destroy]
    
    # 元々あった確認画面もここに入れるとスッキリする
    member do
      get 'confirm'
    end
  end

  # --- 💡 2. いいね一覧機能を追加 (ヘッダー用リンクなど) ---
  # ユーザーに紐付くものなので、usersのリソース内に書くか、単独で定義します
  # 今回は要件に合わせ、ログインユーザーの情報を出すための「単独URL」として定義
  get 'favorites' => 'favorites#index'
  
end