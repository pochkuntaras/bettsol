require_relative '../acceptance_helper'

feature 'Delete question' do
  given(:user) { create :user }
  given!(:question) { create :question }

  scenario 'No author can not delete questions' do
    log_in user

    visit root_path

    expect(page).not_to have_link 'Delete', href: question_path(question)
  end

  scenario 'Author can delete your questions' do
    log_in question.user

    visit root_path

    expect(page).to have_content question.title
    expect(page).to have_link 'More', href: question_path(question)

    click_link 'Delete', href: question_path(question)

    expect(page).to have_current_path root_path
    expect(page).to have_content 'Question was successfully destroyed.'

    expect(page).not_to have_content question.title
    expect(page).not_to have_link 'More', href: question_path(question)
  end
end
