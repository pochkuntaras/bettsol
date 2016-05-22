class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each { |user| DailyMailer.digest(user).deliver_later } if Question.digest.exists?
  end
end
