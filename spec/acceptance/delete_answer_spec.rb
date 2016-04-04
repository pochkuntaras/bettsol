require_relative 'acceptance_helper'

feature 'Delete answer' do
  given!(:answer) { create :answer }

  scenario 'No author can not delete answers' do
    log_in create(:user)

    visit question_path(answer.question)

    expect(page).not_to have_link 'Delete', href: answer_path(answer)
  end

  scenario 'Author can delete your answers', js: true do
    log_in answer.user

    visit question_path(answer.question)

    expect(page).to have_content answer.content

    click_link 'Delete', href: answer_path(answer)

    expect(page).to have_current_path question_path(answer.question)
    expect(page).not_to have_content answer.content
  end
end
