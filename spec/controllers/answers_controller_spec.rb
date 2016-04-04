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

RSpec.describe AnswersController, type: :controller do
  log_in_user

  let(:question) { create :question }

  describe 'POST #create' do
    it 'should save the answer with current user as author' do
      post :create, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer).user).to eq @user
    end

    context 'with valid attributes' do
      it 'should save the answer to the question' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'should redirect to show question after created the answer' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    describe 'PATCH #update' do
      log_in_user

      let!(:answer) { create :answer }
      let!(:user_answer) { create :answer, user: @user }
      let(:attributes_updated_answer) { attributes_for :updated_answer }

      it 'should does not update the question if current user is not author' do
        patch :update, question_id: answer.question, id: answer, answer: attributes_updated_answer, format: :js

        answer.reload

        expect(answer.content).to_not eq attributes_updated_answer[:content]
      end

      it 'should update the question if current user as author' do
        patch :update, question_id: user_answer.question, id: user_answer, answer: attributes_updated_answer, format: :js

        user_answer.reload

        expect(user_answer.content).to eq attributes_updated_answer[:content]
      end
    end

    context 'with invalid attributes' do
      it 'should does not save the invalid answer to the question' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer }
    let!(:user_answer) { create :answer, user: @user }

    it 'should delete the answer if user is author of the answer' do
      expect{
        delete :destroy, question_id: user_answer.question, id: user_answer, format: :js
      }.to change(Answer, :count).by(-1)
    end

    it 'should does not delete the answer if user is not author of the answer' do
      expect{
        delete :destroy, question_id: answer.question, id: answer, format: :js
      }.to_not change(Answer, :count)
    end

    it 'should render nothing' do
      delete :destroy, question_id: user_answer.question, id: user_answer, format: :js
      expect(response).to render_template nil
    end
  end

  describe 'PATCH #best' do
    log_in_user

    context 'current user as author the question' do
      let!(:user_question) { create :question_with_answers, user: @user }
      let(:answer) { user_question.answers.first }

      before { patch :best, question_id: user_question, id: answer, format: :js }

      it { expect(response).to render_template :best }

      it 'should choose the answer as the best' do
        answer.reload
        expect(answer.best).to eq true
      end
    end

    context 'current user as not author the question' do
      let!(:question) { create :question_with_answers}
      let(:answer) { question.answers.first }

      it 'should not choose the answer as the best' do
        patch :best, question_id: question, id: answer, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end
  end
end
