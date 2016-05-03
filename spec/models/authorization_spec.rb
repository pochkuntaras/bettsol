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

require 'rails_helper'

RSpec.describe Authorization, type: :model do
  subject { build :authorization }

  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }
end
