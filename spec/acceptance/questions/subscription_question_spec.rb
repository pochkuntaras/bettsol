require_relative '../acceptance_helper'

feature 'Subscription question' do
  given(:question) { create :question }
  given(:answer) { create :answer, question: question }
  given(:subscription) { create :subscription, question: question }

  scenario 'Sending emails to subscriber', js: true do
    clear_emails

    SubscriptionQuestionMailer.new_answer(subscription.subscriber, answer).deliver_now

    open_email subscription.subscriber.email

    expect(current_email.subject).to eq "New answer to [#{question.title}] | BettSol"
    expect(current_email).to have_content answer.content

    current_email.click_link question.title

    expect(page).to have_current_path question_path(question)
  end
end
