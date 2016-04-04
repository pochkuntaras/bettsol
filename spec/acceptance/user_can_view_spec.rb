require_relative 'acceptance_helper'

feature 'User can view' do
  given(:questions) { create_list :question_with_answers, 2 }
  given!(:question) { questions.first }

  before { visit root_path }

  scenario 'User can view listing questions' do
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_link 'More', href: question_path(question)
    end
  end

  scenario 'User can view the question and answers it' do
    click_link 'More', href: question_path(question)

    expect(page).to have_current_path question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.content

    question.answers.each { |answer| expect(page).to have_content answer.content }
  end
end
