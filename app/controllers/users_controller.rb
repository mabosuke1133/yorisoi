class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @user = current_user
    # 【要件1】ログインユーザーの投稿だけを取得
    @posts = @user.posts.order(created_at: :desc)
  end

  def destroy
    current_user.destroy        # ユーザーの削除
    reset_session               # セッション破棄（ログアウト）
    flash[:notice] = "退会が完了しました。"
    redirect_to new_user_registration_path # 新規登録画面へリダイレクト
  end
end