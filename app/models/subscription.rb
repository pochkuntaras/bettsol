# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :question, touch: true
  belongs_to :subscriber, class_name: User, foreign_key: :user_id

  validates :user_id, :question_id, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
end
