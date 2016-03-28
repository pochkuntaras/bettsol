require 'rails_helper'

feature 'User trying answer to the question' do
  given!(:question) { create :question }

  feature 'Authenticated user' do
    given(:user) { create :user }
    given(:answer) { attributes_for :answer }
    given(:invalid_answer) { attributes_for :invalid_answer }

    before { log_in(user) }

    scenario 'User created answer to the question', js: true do
      create_answer_to_queston question, answer

      expect(page).to have_current_path question_path(question)
      expect(page).to have_content 'Your answer was successfully created.'

      within '.question__answers' do
        expect(page).to have_content answer[:content]
      end

      expect(page).to have_field 'Content', with: ''
    end

    scenario 'User trying create invalid answer to the question', js: true do
      create_answer_to_queston question, invalid_answer

      expect(page).to have_content 'Your answer was not created!'
      expect(page).to have_field 'Content', with: invalid_answer[:content]
    end
  end

  scenario 'Not authenticated user trying answer to the question' do
    visit question_path(question)

    click_link 'Sign in to answer the question'

    expect(page).to have_current_path new_user_session_path
  end
end
