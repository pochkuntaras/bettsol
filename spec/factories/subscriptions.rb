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

FactoryGirl.define do
  factory :subscription do
    user
    question
  end
end
