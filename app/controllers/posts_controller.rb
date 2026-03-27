class PostsController < ApplicationController
  # 🟢 修正：管理者かユーザー、どちらかがログインしていればOKにする
  before_action :authenticate_any!
  # 🟢 修正：編集などは本人、または管理者ならOKにするロジックを ensure_correct_user 内で調整
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    # 1. 土台（全員分）
    @posts = Post.all

    # 2. 検索実行
    if params[:keyword].present?
      # 💡 第一引数に "partial_match" を明示的に渡すことで、モデルの分岐を動かします！
      @posts = Post.looks("partial_match", params[:keyword])
    end

    # 3. 並び替え
    @posts = @posts.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    # 💡 この1行が、投稿フォームの「空の入力欄」を作るために必要
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id if user_signed_in? # 管理者が投稿する場合は別途検討
    if @post.save
      redirect_to posts_path, notice: "つぶやきをみんなに届けました！"
    else
      render :new
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿を更新しました！"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    # 管理者、もしくは投稿者本人の場合のみ削除を許可
    if @post.user == current_user || admin_signed_in?
      @post.destroy
      redirect_to posts_path, notice: "投稿を削除しました"
    else
      redirect_to posts_path, alert: "権限がありません"
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :priority, :image, :emotion_level)
  end

  # 🟢 本人確認のメソッドを管理者の権限も含めて調整
  def ensure_correct_user
    @post = Post.find(params[:id])
    # 「投稿した本人」でもなく「管理者」でもない場合は弾く
    unless (user_signed_in? && @post.user == current_user) || admin_signed_in?
      redirect_to posts_path, alert: "権限がありません。"
    end
  end

  # 🆕 管理者またはユーザーのどちらかがログインしているかチェック
  def authenticate_any!
    if admin_signed_in?
      # OK
    elsif user_signed_in?
      # OK
    else
      # どちらでもなければログイン画面へ
      redirect_to new_user_session_path, alert: "ログインが必要です。"
    end
  end
end