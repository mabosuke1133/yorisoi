class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 🟢 ログインした後の遷移先
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      admin_users_path # 管理者はログイン後、ユーザー一覧（管理画面）へ
    else
      posts_path       # 一般ユーザーはログイン後、投稿一覧（タイムライン）へ
    end
  end

  protected

  def configure_permitted_parameters
    # もし操作しているのが「管理者(Admin)」モデルなら
    if resource_name == :admin
      devise_parameter_sanitizer.permit(:sign_up, keys: [:invitation_code])
      
    # もし操作しているのが「一般ユーザー(User)」モデルなら
    elsif resource_name == :user
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
  end

  private

  # 🔴 ログアウトした後の遷移先
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      # 管理者がログアウトしたら管理者用ログイン画面へ
      new_admin_session_path
    else
      # 一般ユーザーがログアウトしたら、ログイン画面へ
      new_user_session_path
    end
  end
end