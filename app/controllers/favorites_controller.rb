class FavoritesController < ApplicationController
  before_action :authenticate_user! # ログインしていないといいねできないようにする

  # 💡 いいねを作る（カウント+1）
  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    favorite.save
    # 直前のページに戻る（一覧なら一覧、詳細なら詳細）
    redirect_back(fallback_location: root_path)
  end

  # 💡 いいねを消す（カウント-1）
  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end

  # 💡 いいね一覧
  def index
    # ログインユーザーがいいねした投稿（favorite_posts）を全て取得
    @favorite_posts = current_user.favorite_posts
  end
end