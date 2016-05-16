require 'rails_helper'

describe 'Answers API' do
  let(:token) { create(:access_token).token }
  let!(:question) { create :question }
  let!(:answer) { create :answer, question: question }

  describe 'GET #index' do
    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Collectible', 'answer', 1, %w(id question_id content created_at updated_at best)

    def do_request(params = {})
      get api_v1_question_answers_path({ question_id: question }.merge(params)), format: :json
    end
  end

  describe 'GET #show' do
    let(:comments) { create_list :comment, 2, commentable: answer }
    let!(:comment) { comments.first }
    let!(:attachment) { create :attachment, attachable: answer }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Attributable', 'answer', %w(id question_id content created_at updated_at best), [], 'answer/'
    it_behaves_like 'API Collectible', 'comment', 2, %w(id content created_at updated_at), 'answer/'
    it_behaves_like 'API Collectible', 'attachment', 1, %w(id identifier url), 'answer/'

    def do_request(params = {})
      get api_v1_question_answer_path({ question_id: question, id: answer }.merge(params)), format: :json
    end
  end

  describe 'POST #create' do
    let(:attributes) { attributes_for :answer }

    it_behaves_like 'API Authorizable'

    def do_request(params = {})
      post api_v1_question_answers_path({ question_id: question, answer: attributes }.merge(params)), format: :json
    end

    let(:user) { create :user }
    let(:token) { create(:access_token, resource_owner_id: user.id).token }

    context 'with valid attributes' do
      it { expect { do_request access_token: token }.to change(user.answers, :count).by(1) }
      it { expect{ do_request access_token: token }.to change(question.answers, :count).by(1) }

      context 'response' do
        before { do_request access_token: token }

        it { expect(response).to have_http_status(:created) }
        it { expect(response.body).to be_json_eql(question.id).at_path('answer/question_id') }
        it { attributes.each { |k, v| expect(response.body).to be_json_eql(v.to_json).at_path("answer/#{k}") } }
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for :invalid_answer }

      it { expect{ do_request access_token: token }.to_not change(Answer, :count) }

      context 'response' do
        before { do_request access_token: token }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.body).to have_json_path('errors') }
      end
    end
  end
end
