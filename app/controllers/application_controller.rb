class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時にnameを許容
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # 情報更新時にnameを許容
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

private

  # 退会（アカウント削除）後に新規登録画面へ飛ばす
  def after_sign_out_path_for(resource_or_scope)
    new_user_registration_path
  end