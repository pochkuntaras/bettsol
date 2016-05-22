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

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { build :subscription }

  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
end
