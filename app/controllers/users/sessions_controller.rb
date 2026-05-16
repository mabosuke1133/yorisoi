class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:guest_sign_in, :guest_admin_sign_in], raise: false

  # 一般スタッフ用のログイン処理
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストスタッフ（一般ユーザー）としてログインしました。'
  end

  # 管理者（グループオーナー）用のログイン処理
  def guest_admin_sign_in
    user = Admin.guest_admin
    sign_in user
    redirect_to root_path, notice: 'ゲスト管理者としてログインしました。'
  end
end