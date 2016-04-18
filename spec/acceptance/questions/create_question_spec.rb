require_relative '../acceptance_helper'

feature 'Create question' do
  feature 'Authenticated user' do
    given(:user) { create :user }
    given(:attributes_question) { attributes_for :question }
    given(:attributes_invalid_question) {{ title: 'I am do not know how fill this form!', content: nil }}

    before { log_in user }

    scenario 'User created question' do
      create_question attributes_question

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content attributes_question[:title]
      expect(page).to have_content attributes_question[:content]
    end

    scenario 'User trying create invalid question' do
      create_question attributes_invalid_question

      expect(page).to have_content 'Your question was not created!'
      expect(page).to have_field 'Title', with: attributes_invalid_question[:title]
      expect(page).to have_field 'Content', with: attributes_invalid_question[:content]
    end
  end

  scenario 'Not authenticated user does not create a new question' do
    visit root_path

    click_link 'Add new question'

    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
