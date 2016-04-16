require_relative '../acceptance_helper'

feature 'Vote for question' do
  given(:user) { create :user }
  given!(:question) { create :question }

  scenario 'Author can not vote for his question, but can see rating' do
    log_in question.user

    visit question_path(question)

    within "#question_#{question.id}" do
      expect(page).to have_content "Rating: #{question.rating}"
    end

    expect(page).not_to have_link href: like_question_path(question)
    expect(page).not_to have_link href: dislike_question_path(question)
    expect(page).not_to have_link href: indifferent_question_path(question)
  end

  context 'Authenticated user' do
    background do
      log_in user

      visit question_path(question)
    end

    scenario 'User can like the question', js: true do
      within "#question_#{question.id}" do
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_selector("a[href='#{like_question_path(question)}']", visible: true)

        page.find(:xpath, "//a[@href='#{like_question_path(question)}']").click

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_selector("a[href='#{like_question_path(question)}']", visible: false)
      end
    end

    scenario 'User can dislike the question', js: true do
      within "#question_#{question.id}" do
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_selector("a[href='#{dislike_question_path(question)}']", visible: true)

        page.find(:xpath, "//a[@href='#{dislike_question_path(question)}']").click

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_selector("a[href='#{dislike_question_path(question)}']", visible: false)
      end
    end

    scenario 'User can be indifferent to the question', js: true do
      within "#question_#{question.id}" do
        expect(page).to have_selector("a[href='#{indifferent_question_path(question)}']", visible: false)

        page.find(:xpath, "//a[@href='#{like_question_path(question)}']").click

        expect(page).to have_selector("a[href='#{indifferent_question_path(question)}']", visible: true)

        page.find(:xpath, "//a[@href='#{indifferent_question_path(question)}']").click

        expect(page).to have_content 'Rating: 0'
        expect(page).to have_selector("a[href='#{like_question_path(question)}']", visible: true)
        expect(page).to have_selector("a[href='#{dislike_question_path(question)}']", visible: true)
        expect(page).to have_selector("a[href='#{indifferent_question_path(question)}']", visible: false)
      end
    end
  end
end
