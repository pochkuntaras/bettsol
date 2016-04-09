require_relative 'acceptance_helper'

feature 'Edit answer' do
  given!(:answer) { create :answer }
  given(:attributes_updated_answer) { attributes_for :updated_answer }

  scenario 'No author can not edit answer' do
    log_in create(:user)

    visit question_path(answer.question)

    within "#answer_#{answer.id}" do
      expect(page).not_to have_button 'Edit'
    end
  end

  scenario 'Author can edit your answer', js: true do
    log_in answer.user

    visit question_path(answer.question)

    within "#answer_#{answer.id}" do
      expect(page).to have_css(:form, visible: false)

      click_on 'Edit'

      expect(page).to have_css(:form, visible: true)
      expect(page).to have_field 'answer[content]', type: 'textarea', with: answer.content

      fill_in 'answer[content]', with: attributes_updated_answer[:content]

      click_on 'Update'

      expect(page).to have_content attributes_updated_answer[:content]
    end

    expect(page).to have_current_path question_path(answer.question)
  end
end
