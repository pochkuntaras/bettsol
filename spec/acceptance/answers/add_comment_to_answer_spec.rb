require_relative '../acceptance_helper'

feature 'Add comment to answer' do
  given(:user) { create :user }
  given(:answer) { create :answer }
  given(:attributes_comment) { attributes_for :comment }
  given(:attributes_invalid_comment) { attributes_for :invalid_comment }

  context 'Authenticated user' do
    background do
      log_in user

      visit question_path(answer.question)
    end

    scenario 'User can add comment to the answer', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_content attributes_comment[:content]

        within "form[action='#{answer_comments_path(answer)}']" do
          fill_in 'comment[content]', with: attributes_comment[:content]

          page.find('input[type="submit"]').click

          expect(page).to have_field 'comment[content]', with: nil
          expect(page).to_not have_selector '.validation-error'
        end

        expect(page).to have_content attributes_comment[:content]
      end
    end

    scenario 'User trying add invalid comment to the answer', js: true do
      within "#answer_#{answer.id} form[action='#{answer_comments_path(answer)}']" do
        fill_in 'comment[content]', with: attributes_invalid_comment[:content]

        page.find('input[type="submit"]').click

        expect(page).to have_field 'comment[content]', attributes_invalid_comment[:content]
        expect(page).to have_selector '.validation-error'
      end
    end
  end

  scenario 'Not authenticated user trying add comment to the answer' do
    visit question_path(answer.question)

    expect(page).to_not have_selector("form[action='#{answer_comments_path(answer)}']")
  end
end
