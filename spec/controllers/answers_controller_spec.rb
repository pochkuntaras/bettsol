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
  let(:votable) { create :answer }
  let(:user_votable) { create :answer, user: @user }

  it_behaves_like 'voted'

  describe 'POST #create' do
    it 'should save the answer to the question' do
      expect {
        post :create, question_id: question, answer: attributes_for(:answer), format: :json
      }.to change(question.answers, :count).by(1)
    end

    it 'should does not save the invalid answer to the question' do
      expect {
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json
      }.to_not change(Answer, :count)
    end

    context 'with valid attributes' do
      before { post :create, question_id: question, answer: attributes_for(:answer), format: :json }

      it { expect(response).to have_http_status(:created) }
      it { expect(assigns(:answer).user).to eq @user }
    end

    context 'with invalid attributes' do
      before { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response_json['errors']).to be_present }
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create :answer }
    let!(:user_answer) { create :answer, user: @user }
    let(:attributes_updated_answer) { attributes_for :updated_answer }

    it 'should does not update the question if current user is not author' do
      patch :update, id: answer, answer: attributes_updated_answer, format: :js

      answer.reload

      expect(answer.content).to_not eq attributes_updated_answer[:content]
    end

    it 'should update the question if current user as author' do
      patch :update, id: user_answer, answer: attributes_updated_answer, format: :js

      user_answer.reload

      expect(assigns(:answer)).to eq user_answer
      expect(assigns(:question)).to eq user_answer.question
      expect(user_answer.content).to eq attributes_updated_answer[:content]
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer }
    let!(:user_answer) { create :answer, user: @user }

    it { expect{delete :destroy, id: user_answer, format: :json }.to change(Answer, :count).by(-1) }
    it { expect{delete :destroy, id: answer, format: :json}.to_not change(Answer, :count) }

    it 'should render nothing' do
      delete :destroy, id: user_answer, format: :json
      expect(response).to render_template nil
    end
  end

  describe 'PATCH #best' do
    context 'current user as author the question' do
      let!(:user_question) { create :question_with_answers, user: @user }
      let(:answer) { user_question.answers.first }

      before { patch :best, question_id: user_question, id: answer, format: :js }

      it { expect(assigns(:answer)).to eq answer }
      it { expect(assigns(:question)).to eq user_question }
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
