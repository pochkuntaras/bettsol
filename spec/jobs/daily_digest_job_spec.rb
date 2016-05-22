require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_list :user, 2 }

  it 'should sending digest for all users if there are questions' do
    create :question, created_at: Time.now - 1.day, user: users.first
    users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
    DailyDigestJob.perform_now
  end

  it 'should does not sending digest if there are no questions' do
    users.each { |user| expect(DailyMailer).to_not receive(:digest).with(user) }
    DailyDigestJob.perform_now
  end
end
