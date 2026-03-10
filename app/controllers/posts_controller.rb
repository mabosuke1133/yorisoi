class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    if user_signed_in?
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
    @post.user_id = current_user.id
    if @post.save
      redirect_to posts_path, notice: "つぶやきをみんなに届けました！"
    else
      # 保存に失敗した場合、ここ（入力画面）に戻ってくる
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

  def confirm
    # 🆕 IDを元に、削除しようとしている投稿を探して @post に入れる
    @post = Post.find(params[:id])
  end

  # --- ここから下に「身内用」のメソッドをまとめる ---
  private

  # 門番（許可する項目をここにすべて書く）
  def post_params
    params.require(:post).permit(:title, :body, :priority, :image)
  end

  # 本人確認のメソッド（もし以前作っていたならここに入れる）
  def ensure_correct_user
    @post = Post.find(params[:id])
    if @post.user != current_user
      redirect_to posts_path, alert: "権限がありません。"
    end
  end
end