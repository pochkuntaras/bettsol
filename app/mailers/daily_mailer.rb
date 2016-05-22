class DailyMailer < ApplicationMailer
  def digest(user)
    @digest_questions = Question.digest
    mail to: user.email, subject: 'Daily digest | BettSol'
  end
end
