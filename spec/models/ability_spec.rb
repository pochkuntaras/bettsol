require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'user is guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  context 'user is authenticated' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }

    it { should be_able_to :read, :all }
    it { should be_able_to :create, Comment }
    it { should_not be_able_to :manage, :all }

    context 'question' do
      let(:another_question) { create :question }
      let(:liked_question) { create(:like, user: user, votable: another_question).votable }

      it { should be_able_to :create, Question }
      it { should be_able_to :indifferent, liked_question, user.voted_for?(another_question) }
      it { should_not be_able_to :like, liked_question, user.voted_for?(another_question) }
      it { should_not be_able_to :dislike, liked_question, user.voted_for?(another_question) }

      context 'user is author' do
        it { should be_able_to :update, question, user: user }
        it { should be_able_to :destroy, question, user: user }
        it { should_not be_able_to :vote, question, user: user }
      end

      context 'user is not author' do
        it { should be_able_to :vote, another_question, user: user }
        it { should_not be_able_to :update, another_question, user: user }
        it { should_not be_able_to :destroy, another_question, user: user }
      end
    end

    context 'answer' do
      let(:answer) { create :answer, user: user }
      let(:another_answer) { create :answer, question: question }
      let(:liked_answer) { create(:like, user: user, votable: another_answer).votable }

      it { should be_able_to :create, Answer }
      it { should be_able_to :indifferent, liked_answer, user.voted_for?(liked_answer) }
      it { should_not be_able_to :like, liked_answer, user.voted_for?(liked_answer) }
      it { should_not be_able_to :dislike, liked_answer, user.voted_for?(liked_answer) }

      context 'user is author' do
        it { should be_able_to :update, answer, user: user }
        it { should be_able_to :destroy, answer, user: user }
        it { should_not be_able_to :vote, answer, user: user }
      end

      context 'user is not author' do
        it { should be_able_to :vote, another_answer, user: user }
        it { should_not be_able_to :update, another_answer, user: user }
        it { should_not be_able_to :destroy, another_answer, user: user }
      end

      context 'best' do
        let(:best_answer) { create :answer, question: question, best: true }

        context 'user is author question' do
          it { should be_able_to :best, another_answer, another_answer.question.user == user }
          it { should be_able_to :best, another_answer, best: false }
        end

        context 'user is not author question' do
          it { should_not be_able_to :best, answer, answer.question.user != user }
          it { should_not be_able_to :best, best_answer, best: true }
        end
      end
    end

    context 'profile' do
      it { should be_able_to :index, :profile, user: user }
      it { should be_able_to :me, :profile, user: user }
    end

    context 'subscription' do
      it { should be_able_to :create, Subscription }

      context 'current user is subscriber' do
        let(:subscription) { create :subscription, user: user }

        it { should be_able_to :destroy, subscription, user: user }
      end

      context 'current user is not subscriber' do
        let(:another_subscription) { create :subscription }

        it { should_not be_able_to :destroy, another_subscription, user: user }
      end
    end
  end
end
