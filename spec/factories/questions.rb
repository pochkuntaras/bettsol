# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :question do
    title 'Question title'
    content 'Description of the problem'
  end

  factory :invalid_question, class: Question do
    title nil
    content nil
  end
end
