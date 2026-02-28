class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    # 投稿詳細画面から削除ボタンを押す想定
    PostComment.find(params[:id]).destroy
    redirect_to admin_post_path(params[:post_id]), notice: "コメントを削除しました"
  end
end