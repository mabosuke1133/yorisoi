class PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    if @comment.save
      redirect_to post_path(@post), notice: "コメントを投稿しました"
    else
      # 💡 保存失敗時の処理（バリデーションを入れるなら必要）
      @post_comment = PostComment.new # 入力欄をリセット
      render "posts/show"
    end
  end

  def destroy
    # 💡 削除するコメントから直接 post_id を取得すれば、引数ミスを防げます
    comment = PostComment.find(params[:id])
    post = comment.post  # コメントが紐付いている投稿を特定
    comment.destroy
    redirect_to post_path(post), alert: "コメントを削除しました"
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end