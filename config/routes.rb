Rails.application.routes.draw do
  # 1. サイトの根幹（Top / About）
  root to: 'homes#top'
  get 'about' => 'homes#about'
  get 'search' => 'searches#search'
  get "search" => "searches#search" # 既存の定義を維持

  # 2. 認証・ログイン機能 (Devise)
  # --- 認証（Devise）の設定 ---
  # 一般スタッフ用と管理者用でログイン口を完全に分離。
  # スタッフ情報はカスタマイズ性を高めるため、専用のコントローラーを指定。
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

  # --- フォロー機能（自己参照のリレーション） ---
  # ユーザー同士の繋がりを表現。
  resources :users, only: [:show, :destroy] do
    # 💡 フォロー/解除のためのルート
    resource :relationships, only: [:create, :destroy]
    
    # 💡 一覧表示用のルート
    member do
      get :followings, :followers
    end
  end

  # 4. 投稿関連（コメント・いいね）
  # --- 💡 いいね一覧機能を追加 (ヘッダー用リンクなど) ---
  get 'favorites' => 'favorites#index'

  resources :posts do
    # コメントは投稿に紐付くため、中に書く（ネスト）
    resources :post_comments, only: [:create, :destroy]

    # --- 💡 いいね機能を追加 (ネストさせる) ---
    # 単数形の resource にすることで「一人が一つの投稿に一回だけいいね」という構造になります
    resource :favorites, only: [:create, :destroy]
    
    # 元々あった確認画面もここに入れるとスッキリする
    member do
      get 'confirm'
    end
  end

  # 5. グループ・コミュニティ機能
  resources :groups do
    resources :permits, only: [:create, :destroy, :update]
    resources :group_messages, only: [:create]
  end

  # 6. 管理者専用機能 (Namespace)
  # URLの頭に /admin/ を付与し、管理者以外が絶対に触れない領域としてディレクトリを物理的に分離。
  # 現場のガバナンス（投稿削除権限など）を担保。
  namespace :admin do
    resources :users, only: [:index, :show, :destroy]
    
    # 💡 管理者は投稿の一覧・詳細・削除ができる
    resources :posts, only: [:index, :show, :destroy] do
      # 💡 管理者は投稿に紐付くコメントを削除できる
      resources :post_comments, only: [:destroy]
    end
  end
end