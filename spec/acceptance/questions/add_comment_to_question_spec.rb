require_relative '../acceptance_helper'

feature 'Add comment to question' do
  given(:user) { create :user }
  given(:question) { create :question }
  given(:attributes_comment) { attributes_for :comment }
  given(:attributes_invalid_comment) { attributes_for :invalid_comment }

  context 'Authenticated user' do
    background do
      log_in user

      visit question_path(question)
    end

    scenario 'User can add comment to the question', js: true do
      expect(page).to_not have_content attributes_comment[:content]

      within "form[action='#{question_comments_path(question)}']" do
        fill_in 'comment[content]', with: attributes_comment[:content]

        page.find('input[type="submit"]').click

        expect(page).to have_field 'comment[content]', with: nil
        expect(page).to_not have_selector '.validation-error'
      end

      expect(page).to have_content attributes_comment[:content]
    end

    scenario 'User trying add invalid comment to the question', js: true do
      within "form[action='#{question_comments_path(question)}']" do
        fill_in 'comment[content]', with: attributes_invalid_comment[:content]

        page.find('input[type="submit"]').click

        expect(page).to have_field 'comment[content]', attributes_invalid_comment[:content]
        expect(page).to have_selector '.validation-error'
      end
    end
  end

  scenario 'Not authenticated user trying add comment to the question' do
    visit question_path(question)

    expect(page).to_not have_selector("form[action='#{question_comments_path(question)}']")
  end
end
