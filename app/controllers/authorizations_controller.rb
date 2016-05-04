# == Schema Information
#
# Table name: authorizations
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider           :string           not null
#  uid                :string           not null
#  confirmation_token :string           not null
#  confirmed_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class AuthorizationsController < ApplicationController
  before_action :set_authorization, only: :confirm

  def new
  end

  def create
    User.find_for_oauth(OmniAuth::AuthHash.new(session['devise.provider_data']), params[:email])
    redirect_to root_path, notice: "Confirmation letter has been sent on #{params[:email]}."
  rescue ActiveRecord::RecordInvalid
    redirect_to new_user_registration_path, alert: 'Error authorization, please try again!'
  end

  def confirm
    if @authorization.confirmation_token == params[:token] && @authorization.update(confirmed_at: Time.now)
      flash[:notice] = 'Authorization was successfully confirmed.'
      sign_in_and_redirect @authorization.user
    else
      redirect_to root_path, alert: 'Invalid authorization confirmation!'
    end
  end

  private

  def set_authorization
    @authorization = Authorization.find(params[:id])
  end
end
