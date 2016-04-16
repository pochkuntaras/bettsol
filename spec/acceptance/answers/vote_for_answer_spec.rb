require_relative '../acceptance_helper'

feature 'Vote for answer' do
  given(:user) { create :user }
  given!(:answer) { create :answer }

  scenario 'Author can not vote for his answer, but can see rating' do
    log_in answer.user

    visit question_path(answer.question)

    within "#answer_#{answer.id}" do
      expect(page).to have_content "Rating: #{answer.rating}"
    end

    expect(page).not_to have_link href: like_answer_path(answer)
    expect(page).not_to have_link href: dislike_answer_path(answer)
    expect(page).not_to have_link href: indifferent_answer_path(answer)
  end

  context 'Authenticated user' do
    background do
      log_in user

      visit question_path(answer.question)
    end

    scenario 'User can like the answer', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_selector("a[href='#{like_answer_path(answer)}']", visible: true)

        page.find(:xpath, "//a[@href='#{like_answer_path(answer)}']").click

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_selector("a[href='#{like_answer_path(answer)}']", visible: false)
      end
    end

    scenario 'User can dislike the answer', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_selector("a[href='#{dislike_answer_path(answer)}']", visible: true)

        page.find(:xpath, "//a[@href='#{dislike_answer_path(answer)}']").click

        expect(page).to have_content 'Rating: -1'
        expect(page).to have_selector("a[href='#{dislike_answer_path(answer)}']", visible: false)
      end
    end

    scenario 'User can be indifferent to the answer', js: true do
      within "#answer_#{answer.id}" do
        expect(page).to have_selector("a[href='#{indifferent_answer_path(answer)}']", visible: false)

        page.find(:xpath, "//a[@href='#{like_answer_path(answer)}']").click

        expect(page).to have_selector("a[href='#{indifferent_answer_path(answer)}']", visible: true)

        page.find(:xpath, "//a[@href='#{indifferent_answer_path(answer)}']").click

        expect(page).to have_content 'Rating: 0'
        expect(page).to have_selector("a[href='#{like_answer_path(answer)}']", visible: true)
        expect(page).to have_selector("a[href='#{dislike_answer_path(answer)}']", visible: true)
        expect(page).to have_selector("a[href='#{indifferent_answer_path(answer)}']", visible: false)
      end
    end
  end
end
