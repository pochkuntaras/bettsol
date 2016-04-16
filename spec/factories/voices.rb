# == Schema Information
#
# Table name: voices
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  votable_id   :integer
#  votable_type :string
#  solution     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :voice do
    user
    solution 1
  end

  factory :negative_voice, class: Voice do
    user
    solution -1
  end
end
