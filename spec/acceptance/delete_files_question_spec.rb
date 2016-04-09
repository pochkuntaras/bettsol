require_relative 'acceptance_helper'

feature 'Delete files of the question' do
  given(:question) { create :question }
  given!(:attachments) { create_list :attachment, 2, attachable: question }

  background do
    log_in question.user

    visit question_path(question)
  end

  scenario 'Author can delete files when edit question', js: true do
    within "#question_#{question.id}" do
      attachments.each do |attachment|
        expect(page).to have_link attachment.file.identifier, href: attachment.file.url
      end

      click_on 'Edit'

      within "form#edit_question_#{question.id}" do
        attachments.each { |attachment| check("delete_attachment_#{attachment.id}") }

        click_on 'Update'
      end

      attachments.each do |attachment|
        expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
      end
    end
  end
end
