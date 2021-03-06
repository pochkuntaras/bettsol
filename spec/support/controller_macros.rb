module ControllerMacros
  def log_in_user
    before :each do
      @user = create :user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
