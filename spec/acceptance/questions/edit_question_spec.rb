require_relative '../acceptance_helper'

feature 'Edit question' do
  given(:user) { create :user }
  given!(:question) { create :question }
  given(:attributes_updated_question) { attributes_for :updated_question }

  scenario 'No author can not edit questions' do
    log_in user

    visit root_path

    expect(page).not_to have_link 'Edit', href: edit_question_path(question)
  end

  scenario 'Only the author can edit your question', js: true do
    log_in question.user

    visit question_path(question)

    within '.question' do
      expect(page).to have_css('form', visible: false)

      click_on 'Edit'

      expect(page).to have_css('form', visible: true)

      within 'form' do
        expect(page).to have_field 'Title', type: 'text', with: question.title
        expect(page).to have_field 'Content', type: 'textarea', with: question.content

        fill_in 'Title', with: attributes_updated_question[:title]
        fill_in 'Content', with: attributes_updated_question[:content]

        click_on 'Update'
      end

      expect(page).to have_content attributes_updated_question[:title]
      expect(page).to have_content attributes_updated_question[:content]

      expect(page).to have_css(:form, visible: false)
      expect(page).to have_current_path question_path(question)
    end

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content 'Your question was successfully updated.'
  end
end
