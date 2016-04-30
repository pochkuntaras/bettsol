require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :set_current_user_id_in_gon

  private

  def set_current_user_id_in_gon
    gon.current_user_id = current_user.id if current_user
  end
end
