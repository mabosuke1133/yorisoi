Rails.application.routes.draw do
  # =============================================================
  # 1. サイト根幹・認証 (Top / About / Devise)
  # =============================================================
  root to: 'homes#top'
  get 'about'  => 'homes#about'
  get 'search' => 'searches#search'

  # 一般ユーザー用ログイン
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }

  # 管理者用ログイン
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    registrations: 'admins/registrations',
    passwords:     'admins/passwords'
  }

  # =============================================================
  # 2. 一般ユーザー機能 (Public)
  # =============================================================
  
  # ユーザー関連
  get '/users' => redirect('/users/sign_up') # 直接一覧へのアクセスをリダイレクト
  resources :users, only: [:show, :destroy] do
    resource :relationships, only: [:create, :destroy]
    member do
      get :followings, :followers
    end
  end

  # 投稿関連
  get 'favorites' => 'favorites#index' # お気に入り一覧
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    member do
      get 'confirm'
    end
  end

  # 相談機能 (一般)
  resources :consultations, only: [:index, :show, :create] do
    resources :consultation_messages, only: [:create]
  end

  # 簡易的な問題報告/相談 (Issue)
  resources :issues, only: [:create, :destroy]

  # グループ・コミュニティ
  resources :groups do
    resources :permits, only: [:create, :destroy, :update]
    resources :group_messages, only: [:create]
  end

  # =============================================================
  # 3. 管理者専用機能 (Admin Namespace)
  # =============================================================
  namespace :admin do
    # ユーザー管理
    resources :users, only: [:index, :show, :destroy]

    # 投稿・コメント管理
    resources :posts, only: [:index, :show, :destroy] do
      resources :post_comments, only: [:destroy]
    end

    # 相談管理 (admin/consultations)
    resources :consultations, only: [:index, :show, :update] do
      resources :consultation_messages, only: [:create]
    end

    # Issue対応管理
    resources :issues, only: [:index, :update] do
      member do
        patch :complete
      end
    end
  end
end