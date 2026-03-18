class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # 🟢 ログインした後の遷移先
  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      # 管理者も、ログイン後は「チームルーム（グループ一覧）」へ！
      groups_path
    else
      # 一般ユーザーもチームルーム（グループ一覧）へ！
      groups_path
    end
  end

  # 🔴 ログアウトした後の遷移先
  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :admin
      new_admin_session_path
    else
      new_user_session_path
    end
  end

  protected

  def configure_permitted_parameters
    # 管理者(Admin)側の登録
    if resource_name == :admin
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :invitation_code])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
    
    # ユーザー(User)側の登録
    if resource_name == :user
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
  end
end