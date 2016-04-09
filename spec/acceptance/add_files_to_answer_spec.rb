require_relative 'acceptance_helper'

feature 'Add files to answer' do
  given(:question) { create :question }
  given(:attributes_answer) { attributes_for :answer }

  background do
    log_in create(:user)

    visit question_path(question)
  end

  scenario 'The user adds a file when create new answer', js: true do
    within 'form#new_answer' do
      fill_in 'Content', with: attributes_answer[:content]

      2.times { click_on 'Add attachment' }

      all('input[type="file"]').each { |input| input.set("#{Rails.root}/spec/files/smile.txt") }

      click_on 'Reply'
    end

    within '.answers' do
      1.upto(2) { |i| expect(page).to have_link 'smile.txt', href: "/uploads/attachment/file/#{i}/smile.txt" }
    end
  end
end
