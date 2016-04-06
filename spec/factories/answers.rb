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

FactoryGirl.define do
  factory :answer do
    user
    question

    sequence :content do |n|
      "I solved the problem by using the method number #{n}"
    end
  end

  factory :invalid_answer, class: Answer do
    content nil
  end

  factory :updated_answer, class: Answer do
    sequence :content do |n|
      "No problems! I solved the problem by using the method number #{n}"
    end
  end
end
