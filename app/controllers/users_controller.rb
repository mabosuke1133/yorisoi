class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    # 【要件1】ログインユーザーの投稿だけを取得
    @posts = @user.posts.order(created_at: :desc)
  end
end