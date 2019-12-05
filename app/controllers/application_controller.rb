class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    user_path(id: current_user.id)
  end

before_action :configure_permitted_parameters, if: :devise_controller?
 # deviseコントローラーにストロングパラメータを追加する

  protected
  def configure_permitted_parameters
   # サインアップ時にnameのストロングパラメータを追加
   devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
   # アカウント編集の時にnameとprofileのストロングパラメータを追加
   devise_parameter_sanitizer.permit(:account_update, keys: [:username, :info, :user_image])
 end
end
