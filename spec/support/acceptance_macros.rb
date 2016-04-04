module AcceptanceMacros
  def create_question(question)
    visit root_path

    click_link 'Add new question'

    expect(page).to have_current_path new_question_path

    fill_in 'Title', with: question[:title]
    fill_in 'Content', with: question[:content]

    click_on 'Save'
  end

  def create_answer_to_queston(question, answer)
    visit question_path(question)

    within 'form#new_answer' do
      fill_in 'Content', with: answer[:content]

      click_on 'Reply'
    end
  end

  def log_in(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'
  end
end
