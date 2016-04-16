require_relative '../acceptance_helper'

feature 'Delete files of the question' do
  given(:answer) { create :answer }
  given!(:attachments) { create_list :attachment, 2, attachable: answer }

  background do
    log_in answer.user

    visit question_path(answer.question)
  end

  scenario 'Author can delete files when edit answer', js: true do
    within "#answer_#{answer.id}" do
      attachments.each do |attachment|
        expect(page).to have_link attachment.file.identifier, href: attachment.file.url
      end

      click_on 'Edit'

      within "form#edit_answer_#{answer.id}" do
        attachments.each { |attachment| check("delete_attachment_#{attachment.id}") }

        click_on 'Update'
      end

      attachments.each do |attachment|
        expect(page).to_not have_link attachment.file.identifier, href: attachment.file.url
      end
    end
  end
end
