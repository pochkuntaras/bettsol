require_relative '../acceptance_helper'

feature 'User can login with Facebook' do
  let(:email) { 'user@example.com' }

  context 'User trying to sign in with Facebook' do
    background { visit new_user_session_path }

    scenario 'User sign in with Facebook' do
      set_auth :facebook, email

      click_link 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
      expect(page).to have_link('Sign out')
    end
  end

  context 'User is not logged on Facebook' do
    background { visit new_authorization_path }

    scenario 'Invalid Facebook authorization' do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: nil, uid: nil)

      fill_in :email, with: email

      click_on 'Continue'

      expect(page).to have_content('Error authorization, please try again!')
      expect(current_path).to eq new_user_registration_path
    end
  end
end
