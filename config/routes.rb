Rails.application.routes.draw do
  namespace :admin do
    get 'consultations/index'
    get 'consultations/show'
    get 'consultations/update'
    resources :consultations, only: [:index, :show, :update] do
      resources :consultation_messages, only: [:create]
    end
  end
  get 'consultations/index'
  get 'consultations/show'
  # 1. サイトの根幹（Top / About）
  root to: 'homes#top'
  get 'about' => 'homes#about'
  get 'search' => 'searches#search'

  # 2. 認証・ログイン機能 (Devise)
  # 一般スタッフ用と管理者用でログイン口を分離
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    registrations: 'admins/registrations',
    passwords:     'admins/passwords'
  }

  # 3. ユーザー関連（プロフィール・フォロー）
  get '/users' => redirect('/users/sign_up')

  resources :users, only: [:show, :destroy] do
    resource :relationships, only: [:create, :destroy]
    member do
      get :followings, :followers
    end
  end

  # 4. 相談（Issue）機能
  # button_to (POST) で送られてくる /issues をここで受け取ります
  resources :issues, only: [:create, :destroy]

  # 5. 投稿関連（コメント・いいね）
  get 'favorites' => 'favorites#index'

  resources :posts do
    resources :post_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    member do
      get 'confirm'
    end
  end

  # 6. グループ・コミュニティ機能
  resources :groups do
    resources :permits, only: [:create, :destroy, :update]
    resources :group_messages, only: [:create]
  end

  # 7. 管理者専用機能 (Namespace)
  namespace :admin do
    resources :users, only: [:index, :show, :destroy]
    # 管理者用の一覧とステータス更新
    resources :issues, only: [:index, :update] do
      member do
        patch :complete
      end
    end

    resources :posts, only: [:index, :show, :destroy] do
      resources :post_comments, only: [:destroy]
    end
  end

  resources :consultations, only: [:index, :show, :create] do
    resources :consultation_messages, only: [:create]
  end
end