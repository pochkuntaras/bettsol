class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :auth_provider

  def facebook
  end

  def twitter
  end

  private

  def auth_provider
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user && @user.persisted? && @user.authorizations.find_by(provider: auth.provider, uid: auth.uid).confirmed_at
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: params[:action].capitalize if is_navigational_format?
    else
      session['devise.provider_data'] = auth.except('extra')
      redirect_to new_authorization_path
    end
  end
end
