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

require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject { build :answer }

  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should belong_to :user }
  it { should belong_to :question }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :content }

  describe 'best answer' do
    let(:question) { create :question }
    let(:answer) { create :answer, question: question }
    let(:best_answer) { create :answer, best: true, question: question }

    it 'should choose the answer as the best' do
      expect(answer.best).to eq false

      answer.choose_as_best
      answer.reload

      expect(answer.best).to eq true
    end

    it 'should choose old best answer as not the best answer' do
      expect(best_answer.best).to eq true
      expect(answer.best).to eq false

      answer.choose_as_best

      best_answer.reload
      answer.reload

      expect(best_answer.best).to eq false
      expect(answer.best).to eq true
    end
  end

  describe 'sending emails to subscribers' do
    TestAfterCommit.with_commits(true) do
      it 'should does not send emails if there are no subscribers' do
        expect(SubscriptionQuestionJob).to_not receive(:perform_later)
        subject.question.subscribers.destroy_all
        subject.save!
      end

      context 'with subscriptions' do
        before { create :subscription, question: subject.question }

        it 'should send emails all subscribers after save' do
          expect(SubscriptionQuestionJob).to receive(:perform_later).with(subject.question, subject)
          subject.save!
        end

        it 'should does not send emails all subscribers after update' do
          subject.save!
          expect(SubscriptionQuestionJob).to_not receive(:perform_later)
          subject.update(content: 'Updated content the answer.')
        end
      end
    end
  end
end
