require_relative '../acceptance_helper'

feature 'Search' do
  given!(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question }

  scenario 'User can search users' do
    search query: user.email, scope: 'user'

    expect(page).to have_content "User: #{user.email}"

    expect(page).to_not have_content %Q(Question "#{question.title}")
    expect(page).to_not have_content %Q(Answer for "#{question.title}")
  end

  scenario 'User can search questions' do
    search query: 'Help me', scope: 'question'

    expect(page).to have_link %Q(Question "#{question.title}"), href: question_path(question)

    expect(page).to_not have_content %Q(Answer for "#{question.title}")
    expect(page).to_not have_content "User: #{user.email}"
  end

  scenario 'User can search answers' do
    search query: 'solved', scope: 'answer'

    expect(page).to have_link %Q(Answer for "#{question.title}"), href: question_path(question)

    expect(page).to_not have_content %Q(Question "#{question.title}")
    expect(page).to_not have_content "User: #{user.email}"
  end
end
