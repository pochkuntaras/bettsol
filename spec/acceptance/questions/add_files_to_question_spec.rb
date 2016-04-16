require_relative '../acceptance_helper'

feature 'Add files to question' do
  given(:attributes_question) { attributes_for :question }

  background do
    log_in create(:user)

    visit new_question_path
  end

  scenario 'The user adds a file when create new question', js: true do
    fill_in 'Title', with: attributes_question[:title]
    fill_in 'Content', with: attributes_question[:content]

    2.times { click_on 'Add attachment' }

    all('input[type="file"]').each { |input| input.set("#{Rails.root}/spec/files/smile.txt") }

    click_on 'Save'

    1.upto(3) { |i| expect(page).to have_link 'smile.txt', href: "/uploads/attachment/file/#{i}/smile.txt" }
  end
end
