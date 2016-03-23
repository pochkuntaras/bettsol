require 'rails_helper'

feature 'Delete answer' do
  given(:user) { create :user }
  given!(:answer) { create :answer }

  scenario 'No author can not delete answers' do
    log_in user

    visit question_path(answer.question)

    expect(page).not_to have_link 'Delete', href: question_answer_path(answer.question, answer)
  end

  scenario 'Author can delete your answers' do
    log_in answer.user

    visit question_path(answer.question)

    expect(page).to have_content answer.content

    click_link 'Delete', href: question_answer_path(answer.question, answer)

    expect(page).to have_current_path question_path(answer.question)
    expect(page).to have_content 'Your answer was successfully deleted.'
    expect(page).not_to have_content answer.content
  end
end
