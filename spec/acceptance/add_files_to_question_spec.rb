require_relative 'acceptance_helper'

feature 'Add files to question' do
  given(:attributes_question) { attributes_for :question }

  background do
    log_in create(:user)

    visit new_question_path
  end

  scenario 'The user adds a file when create new question' do
    fill_in 'Title', with: attributes_question[:title]
    fill_in 'Content', with: attributes_question[:content]

    attach_file 'File', "#{Rails.root}/spec/files/smile.txt"

    click_on 'Save'

    expect(page).to have_link 'smile.txt', href: '/uploads/attachment/file/1/smile.txt'
  end
end
