# == Schema Information
#
# Table name: authorizations
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider           :string           not null
#  uid                :string           not null
#  confirmation_token :string           not null
#  confirmed_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :authorization do
    user

    sequence :provider do |n|
      "provider_#{n}"
    end

    sequence :uid do |n|
      "42512#{n}"
    end
  end
end
