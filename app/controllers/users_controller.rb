class UsersController < ApplicationController
  before_action :authenticate_user! # ログインしていない人は門前払い
  # 💡 セキュリティ対策：編集・更新は「本人」のみに制限
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    # 💡params[:id] があればその人を、なければ自分を表示するようにすると汎用性が高まる
    @user = params[:id] ? User.find(params[:id]) : current_user
    @posts = @user.posts.order(created_at: :desc)
  end

  def followings
    @user = User.find(params[:id])
    @users = @user.followings
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  def destroy
    current_user.destroy
    # 💡 確実な退会処理：セッションを空にして、ログイン状態を完全にリセット
    reset_session
    flash[:notice] = "退会が完了しました。"
    redirect_to new_user_registration_path
  end

  def index
    # 自分以外のユーザーを全て取得
    @users = User.where.not(id: current_user.id)
  end
end