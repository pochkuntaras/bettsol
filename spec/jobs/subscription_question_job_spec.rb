require 'rails_helper'

RSpec.describe SubscriptionQuestionJob, type: :job do
  let!(:question) { create :question }
  let!(:answer) { create :answer, question: question }
  let!(:subscription) { create_list :subscription, 2, question: question }

  it 'should send emails all subscribers' do
    question.subscribers.each do |subscriber|
      expect(SubscriptionQuestionMailer).to receive(:new_answer).with(subscriber, answer).and_call_original
    end

    SubscriptionQuestionJob.perform_now(question, answer)
  end
end
