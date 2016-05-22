require_relative 'acceptance_helper'

feature 'Daily digest' do
  given!(:user) { create :user }
  given!(:question_before_yesterday) { create(:question, created_at: Time.now - 2.day) }
  given!(:first_digest_question) { create(:question, created_at: Time.parse('00:00:00') - 1.day) }
  given!(:second_digest_question) { create(:question, created_at: Time.now - 1.day) }
  given!(:last_digest_question) { create(:question, created_at: Time.parse('23:59:59') - 1.day) }
  given!(:question_today) { create :question }

  background do
    clear_emails
    DailyMailer.digest(user).deliver_now
    open_email user.email
  end

  scenario 'Digest contains questions for the last day' do
    expect(current_email.subject).to eq 'Daily digest | BettSol'
    expect(current_email).to have_content "Hi! This is digest for last day #{(Time.now - 1.day).strftime('%Y-%m-%d')}."

    [first_digest_question, second_digest_question, last_digest_question].each do |question|
      current_email.click_link question.title
      expect(page).to have_current_path question_path(question)
    end
  end

  scenario 'Digest does not contains questions for the other days' do
    [question_before_yesterday, question_today].each do |question|
      expect(current_email).to_not have_link(question.title)
    end
  end
end
