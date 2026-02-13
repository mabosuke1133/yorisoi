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