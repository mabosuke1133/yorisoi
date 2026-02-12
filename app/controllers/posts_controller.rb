class PostsController < ApplicationController
  # ログインしていないと投稿できないようにする
  before_action :authenticate_user!

  def index
    @posts = Post.all.order(created_at: :desc) # 新しい順に全件取得
  end

  def show
  end

  def edit
  end

  def new
    @post = Post.new # 新しい投稿用の空のインスタンスを作成
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id # ログイン中のユーザーIDを紐付け
    if @post.save
      redirect_to posts_path, notice: "寄り添い（投稿）を公開しました！"
    else
      render :new # 保存失敗時は新規登録画面を再表示
    end
  end

  private

  # 悪意のあるデータ操作を防ぐ「ストロングパラメーター」
  def post_params
    params.require(:post).permit(:title, :body, :emotion_level)
  end
end
