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

require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build :question }

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions) }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  it { expect { subject.save! }.to change(subject.subscriptions, :count).by(1) }

  describe 'digest' do
    let!(:question_before_yesterday) { create(:question, created_at: Time.now - 2.day) }
    let!(:first_digest_question) { create(:question, created_at: Time.parse('00:00:00') - 1.day) }
    let!(:second_digest_question) { create(:question, created_at: Time.now - 1.day) }
    let!(:last_digest_question) { create(:question, created_at: Time.parse('23:59:59') - 1.day) }
    let!(:question_today) { create :question }

    it { expect(Question.digest).to include(first_digest_question, second_digest_question, last_digest_question) }
    it { expect(Question.digest).to_not include(question_before_yesterday, question_today) }
  end
end
