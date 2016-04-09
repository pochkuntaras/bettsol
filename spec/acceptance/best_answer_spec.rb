require_relative 'acceptance_helper'

feature 'Best answer' do
  given!(:question) { create :question_with_answers }
  given(:answer) { question.answers.order('RANDOM()').first }

  scenario 'Author the question can choose the best answer', js: true do
    log_in question.user

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector '.answer_best', match: :first
    end

    click_link 'Best answer', href: best_answer_path(answer)

    within '.answers' do
      expect(page).to have_selector '.answer_best', match: :first
      expect(page).not_to have_link 'Best answer', href: best_answer_path(answer)
    end
  end

  scenario 'Not author the question can not choose the best answer' do
    log_in create(:user)

    visit question_path(question)

    expect(page).not_to have_link 'Best answer', href: best_answer_path(answer)
  end

  scenario 'Another users cannot choose the best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Best answer', href: best_answer_path(answer)
  end
end
