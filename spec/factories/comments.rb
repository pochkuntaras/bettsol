# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  commentable_id   :integer          not null
#  commentable_type :string           not null
#  content          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :comment do
    user

    sequence :content do |n|
      "It is very nice! #{n}"
    end
  end

  factory :invalid_comment, class: Comment do
    user
    content nil
  end
end
