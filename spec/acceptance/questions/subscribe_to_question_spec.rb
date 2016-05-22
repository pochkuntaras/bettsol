require_relative '../acceptance_helper'

feature 'Subscribe to question' do
  given!(:question) { create :question }

  feature 'Authenticated user' do
    given(:user) { create :user }
    given(:subscription) { create :subscription, user: user }

    before { log_in user }

    scenario 'The author subscribed to own question after his created' do
      create_question attributes_for(:question)

      expect(page).to have_link 'Unsubscribe to the question'
    end

    scenario 'User can subscribe to question', js: true do
      visit question_path(question)

      click_link 'Subscribe to the question', href: question_subscriptions_path(question)

      expect(page).to have_link 'Unsubscribe to the question'
      expect(page).to have_content 'Subscription was successfully created.'
    end

    scenario 'User can unsubscribe to question', js: true do
      visit question_path(subscription.question)

      click_link 'Unsubscribe to the question', href: subscription_path(subscription)

      expect(page).to have_link 'Subscribe to the question', href: question_subscriptions_path(subscription.question)
      expect(page).to have_content 'Subscription was successfully destroyed.'
    end
  end

  scenario 'Not authenticated user can not subscribe to question' do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe to the question')
  end
end
