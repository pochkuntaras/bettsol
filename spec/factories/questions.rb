# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

FactoryGirl.define do
  factory :question do
    user

    sequence :title do |n|
      "Help me please! #{n}"
    end

    content 'My problem is very important!'

    factory :question_with_answers do
      transient do
        answers_count 4
      end

      after :create do |question, evaluator|
        FactoryGirl.create_list :answer, evaluator.answers_count, question: question
      end
    end
  end

  factory :invalid_question, class: Question do
    title nil
    content nil
  end
end
