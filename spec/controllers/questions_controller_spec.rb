require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list :question, 2 }

    before { get :index }

    it { expect(assigns(:questions)).to match_array(questions) }
    it { expect(response).to render_template :index }
  end

  describe 'GET #show' do
    let(:question) { create :question }

    before { get :show, id: question }

    it { expect(assigns(:question)).to eq question }
    it { expect(response).to render_template :show }
  end

  describe 'GET #new' do
    log_in_user

    before { get :new }

    it { expect(assigns(:question)).to be_a_new(Question) }
    it { expect(response).to render_template :new }
  end

  describe 'POST #create' do
    log_in_user

    it 'should save the question with current user as author' do
      post :create, question: attributes_for(:question)
      expect(assigns(:question).user).to eq @user
    end

    context 'with valid attributes' do
      it 'should save the question to database' do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(Question, :count).by(1)
      end

      it 'should redirect to page with question' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'should does not save the invalid question' do
        expect {
          post :create, question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 'should render new template if does not create the question' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    log_in_user

    let!(:question) { create :question }
    let!(:user_question) { create :question, user: @user }

    it 'should delete the question if user is author of the question' do
      expect{delete :destroy, id: user_question }.to change(Question, :count).by(-1)
    end

    it 'should does not delete the question if user is not author of the question' do
      expect{delete :destroy, id: question}.to_not change(Question, :count)
    end

    it 'should redirect to page with listing questions' do
      delete :destroy, id: question
      expect(response).to redirect_to root_url
    end
  end
end
