require_relative '../acceptance_helper'

feature 'User can login with Twitter' do
  let(:email) { 'user@example.com' }

  context 'User trying to sign in with Twitter' do
    background { visit new_user_session_path }

    scenario 'Twitter has provided email address' do
      set_auth :twitter, email

      click_link 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account.')
      expect(page).to have_link('Sign out')
    end

    scenario 'Twitter has not provided email address' do
      set_auth :twitter

      click_on 'Sign in with Twitter'

      fill_in :email, with: email

      click_on 'Continue'

      expect(page).to have_content("Confirmation letter has been sent on #{email}.")

      open_email email

      current_email.click_link 'Confirm authorization'

      expect(page).to have_content('Authorization was successfully confirmed.')
    end
  end

  context 'User is not logged on Twitter' do
    background { visit new_authorization_path }

    scenario 'Invalid Twitter authorization' do
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(provider: nil, uid: nil)

      fill_in :email, with: email

      click_on 'Continue'

      expect(page).to have_content('Error authorization, please try again!')
      expect(current_path).to eq new_user_registration_path
    end
  end
end
