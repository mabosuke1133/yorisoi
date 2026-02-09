Rails.application.routes.draw do
  # アプリのトップページ（/）を homesコントローラの topアクションに設定
  root to: 'homes#top' 
  
  # aboutページのURLを /about に設定
  get 'about' => 'homes#about'
end
