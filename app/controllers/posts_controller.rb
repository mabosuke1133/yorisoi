class PostsController < ApplicationController
  # ログインしていないと投稿できないようにする
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc) # 新しい順に全件取得
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  # 【要件10】投稿者本人でない場合は、一覧へリダイレクトさせる（URL直打ち対策）
   if @post.user != current_user
     redirect_to posts_path, alert: "他人の投稿は編集できません。"
   end
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
  
  def update
    @post = Post.find(params[:id])
    # 【要件7 & 8】バリデーションチェック。成功すれば詳細へ、失敗すれば編集画面を再表示
    if @post.update(post_params)
     redirect_to post_path(@post), notice: "投稿を更新しました！"
    else
     render :edit
   end
  end

  def confirm
  @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    # 本人確認（要件10の削除制限も兼ねる）
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: "投稿を削除しました。"
    else
      redirect_to posts_path, alert: "他人の投稿は削除できません。"
    end
  end

  private

  # 悪意のあるデータ操作を防ぐ「ストロングパラメーター」
  def post_params
    params.require(:post).permit(:title, :body, :emotion_level, :image)
  end
end
