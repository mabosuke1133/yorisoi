class PostsController < ApplicationController
  # 🟢 修正：管理者かユーザー、どちらかがログインしていればOKにする
  before_action :authenticate_any!
  # 🟢 修正：編集などは本人、または管理者ならOKにするロジックを ensure_correct_user 内で調整
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    # 管理者の場合は「全投稿」を表示、ユーザーの場合は「フィード（関係する投稿）」を表示
    if admin_signed_in?
      @posts = Post.all
    elsif user_signed_in?
      @posts = current_user.feed
    else
      @posts = Post.all
    end

    if params[:keyword].present?
      @posts = @posts.where('title LIKE ?', "%#{params[:keyword]}%")
    end

    @posts = @posts.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
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
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました。"
  end

  # --- 🆕 confirm アクションは詳細画面からの直接削除（method: :delete）になったので削除しました ---

  private

  def post_params
    params.require(:post).permit(:title, :body, :priority, :image)
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