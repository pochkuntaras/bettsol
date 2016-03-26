require 'rails_helper'

feature 'User authentication' do
  given(:new_user) { attributes_for :user }

  feature 'Authenticated user' do
    given!(:user) { create :user }

    scenario 'User can sign in' do
      visit root_path

      click_link 'Sign in'

      expect(page).to have_current_path new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'User can sign out' do
      log_in user

      visit root_path

      click_link 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
    end

  end

  scenario 'User can sign up' do
    visit new_user_session_path

    click_link 'Sign up'

    expect(page).to have_current_path new_user_registration_path

    fill_in 'Email', with: new_user[:email]
    fill_in 'Password', with: new_user[:password]
    fill_in 'Password confirmation', with: new_user[:password_confirmation]

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_current_path root_path
  end
end
