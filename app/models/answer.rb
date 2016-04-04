# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  content     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  best        :boolean          default(FALSE), not null
#

class Answer < ActiveRecord::Base
  default_scope { order best: :desc }

  belongs_to :user
  belongs_to :question

  validates :user_id, :question_id, :content, presence: true

  def choose_as_best
    transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
