class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ページネーション 1ページ表示数
  PER = 12

  protected

  def configure_permitted_parameters
    added_attrs = %i[name avatar profile]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
  end
end
