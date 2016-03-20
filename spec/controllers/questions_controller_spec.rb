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
    before { get :new }

    it { expect(assigns(:question)).to be_a_new(Question) }
    it { expect(response).to render_template :new }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save the new question to database' do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(Question, :count).by(1)
      end

      it 'should redirect to show question' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question' do
        expect {
          post :create, question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 'should render new template' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end
end
