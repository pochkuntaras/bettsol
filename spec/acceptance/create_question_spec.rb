require 'rails_helper'

feature 'User trying ask question' do
  feature 'Authenticated user' do
    given(:user) { create :user }
    given(:question) { attributes_for :question }
    given(:invalid_question) {{ title: 'I am do not know how fill this form!', content: nil }}

    before { log_in user }

    scenario 'User created question' do
      create_question question

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content question[:title]
      expect(page).to have_content question[:content]
    end

    scenario 'User trying create invalid question' do
      create_question invalid_question

      expect(page).to have_content 'Your question was not created!'
      expect(page).to have_field 'Title', with: invalid_question[:title]
      expect(page).to have_field 'Content', with: invalid_question[:content]
    end
  end

  scenario 'Not authenticated user does not create a new question' do
    visit root_path

    click_link 'Add new question'

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
