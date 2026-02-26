class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # 💡 ログイン後の遷移先を分岐させる
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_users_path # 管理者はユーザー一覧へ
    else
      posts_path # 一般ユーザーは投稿一覧へ
    end
  end

  protected

  def configure_permitted_parameters
    # 新規登録時にnameを許容
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # 情報更新時にnameを許容
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  # 💡 ログアウト後の遷移先を管理者とユーザーで分ける
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      # 管理者がログアウトしたら管理者用ログイン画面へ
      new_admin_session_path
    elsif resource_or_scope == :user
      # 一般ユーザーが退会・ログアウトしたら新規登録画面へ
      reset_session 
      new_user_registration_path
    else
      root_path
    end
  end
end 