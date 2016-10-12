class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception
  before_action :set_locale

  private

  def not_authenticated
    redirect_to main_app.root_path
  end

  def user_not_authorized
    if current_user.has_role?(:admin) || current_user.has_role?(:moderator)
      redirect_to main_app.rails_admin_path, alert: t(:no_permission)
    else
      redirect_to main_app.root_path, alert: t(:no_permission)
    end
  end

  def set_locale
    current_locale = params[:user_locale] || session[:locale]

    locale =
      if current_user
        current_user.locale
      else
        current_locale || http_accept_language.compatible_language_from(I18n.available_locales)
      end

    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale
    else
      session[:locale] = I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
