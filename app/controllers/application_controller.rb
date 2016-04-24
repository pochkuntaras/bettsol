class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_current_user_id_in_gon

  private

  def set_current_user_id_in_gon
    gon.current_user_id = current_user.id if current_user
  end
end
