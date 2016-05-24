class SubscriptionQuestionMailer < ApplicationMailer
  def new_answer(subscriber, answer)
    @answer = answer
    mail to: subscriber.email, subject: "New answer to [#{@answer.question.title}] | BettSol"
  end
end
