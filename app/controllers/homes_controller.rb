class HomesController < ApplicationController
  def top
  end

  def about
  end

  def home
    # 投稿を作成日時の新しい順に並べて、最初から3つだけ取得する
    @latest_posts = Post.order(created_at: :desc).limit(3)
  end
end
