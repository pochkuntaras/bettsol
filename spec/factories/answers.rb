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
#

FactoryGirl.define do
  factory :answer do
    user
    question

    sequence :content do |n|
      %Q(No problems! I solved the problem
         by using the method number #{n})
    end
  end

  factory :invalid_answer, class: Answer do
    content nil
  end
end
