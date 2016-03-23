module AcceptanceHelper
  def create_question(question)
    visit root_path

    click_link 'Add new question'

    expect(page).to have_current_path new_question_path

    fill_in 'Title', with: question[:title]
    fill_in 'Content', with: question[:content]

    click_on 'Submit'
  end

  def create_answer_to_queston(question, answer)
    visit question_path(question)

    fill_in 'Content', with: answer[:content]

    click_on 'Add new answer'
  end

  def log_in(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'
  end
end
