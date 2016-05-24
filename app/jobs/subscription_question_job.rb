class SubscriptionQuestionJob < ActiveJob::Base
  queue_as :default

  def perform(question, answer)
    question.subscribers.find_each do |subscriber|
      SubscriptionQuestionMailer.new_answer(subscriber, answer).deliver_later
    end
  end
end
