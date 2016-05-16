require 'rails_helper'

describe 'Questions API' do
  let(:token) { create(:access_token).token }
  let(:questions) { create_list :question, 2 }
  let!(:question) { questions.first }

  describe 'GET #index' do
    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Collectible', 'question', 2, %w(id title content created_at updated_at)

    def do_request(params = {})
      get api_v1_questions_path(params), format: :json
    end
  end

  describe 'GET #show' do
    let(:comments) { create_list :comment, 2, commentable: question }
    let!(:comment) { comments.first }
    let!(:attachment) { create :attachment, attachable: question }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Attributable', 'question', %w(id title content created_at updated_at), [], 'question/'
    it_behaves_like 'API Collectible', 'comment', 2, %w(id content created_at updated_at), 'question/'
    it_behaves_like 'API Collectible', 'attachment', 1, %w(id identifier url), 'question/'

    def do_request(params = {})
      get api_v1_question_path({ id: question }.merge(params)), format: :json
    end
  end

  describe 'POST #create' do
    let(:user) { create :user }
    let(:token) { create(:access_token, resource_owner_id: user.id).token }
    let(:attributes) { attributes_for :question }

    it_behaves_like 'API Authorizable'

    def do_request(params = {})
      post api_v1_questions_path({ question: attributes }.merge(params)), format: :json
    end

    context 'with valid attributes' do
      it { expect { do_request access_token: token }.to change(user.questions, :count).by(1) }

      context 'response' do
        before { do_request access_token: token }

        it { expect(response).to have_http_status(:created) }
        it { attributes.each { |k, v| expect(response.body).to be_json_eql(v.to_json).at_path("question/#{k}") } }
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { attributes_for :invalid_question }

      it { expect { do_request access_token: token }.to_not change(Question, :count) }

      context 'response' do
        before { do_request access_token: token }

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.body).to have_json_path('errors') }
      end
    end
  end
end
