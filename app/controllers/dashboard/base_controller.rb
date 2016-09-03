class Dashboard::BaseController < ApplicationController
  before_action :require_login
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_authenticated
    redirect_to login_path, alert: t(:please_log_in)
  end

  def not_found
    redirect_to root_path, alert: t(:not_found_alert)
  end
end
