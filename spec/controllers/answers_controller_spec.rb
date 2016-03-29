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

    context 'with invalid attributes' do
      it 'should does not save the invalid answer to the question' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end

      it 'should render new template if does not create the answer' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template partial: 'layouts/_notifications'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer }
    let!(:user_answer) { create :answer, user: @user }

    it 'should delete the answer if user is author of the answer' do
      expect{
        delete :destroy, question_id: user_answer.question, id: user_answer
      }.to change(Answer, :count).by(-1)
    end

    it 'should does not delete the answer if user is not author of the answer' do
      expect{
        delete :destroy, question_id: answer.question, id: answer
      }.to_not change(Answer, :count)
    end

    it 'should redirect to page with question' do
      delete :destroy, question_id: answer.question, id: answer
      expect(response).to redirect_to answer.question
    end
  end
end
