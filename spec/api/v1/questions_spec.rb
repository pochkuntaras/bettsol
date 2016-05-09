require 'rails_helper'

describe 'Questions API' do
  let(:token) { create(:access_token).token }
  let(:questions) { create_list :question, 2 }
  let!(:question) { questions.first }

  describe 'GET #index' do
    context 'authorized' do
      before { get api_v1_questions_path(access_token: token), format: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to have_json_size(2).at_path('questions') }

      %w(id title content created_at updated_at).each do |a|
        it { expect(response.body).to be_json_eql(question.send(a.to_sym).to_json).at_path("questions/0/#{a}") }
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        get api_v1_questions_path, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        get api_v1_questions_path(access_token: 'invalid_token'), format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    let(:comments) { create_list :comment, 2, commentable: question }
    let!(:comment) { comments.first }
    let!(:attachment) { create :attachment, attachable: question }

    context 'authorized' do
      before { get api_v1_question_path(id: question, access_token: token), format: :json }

      it { expect(response).to have_http_status(:ok) }

      %w(id title content created_at updated_at).each do |a|
        it { expect(response.body).to be_json_eql(question.send(a.to_sym).to_json).at_path("question/#{a}") }
      end

      context 'comments' do
        it { expect(response.body).to have_json_size(2).at_path('question/comments') }

        %w(id content created_at updated_at).each do |a|
          it { expect(response.body).to be_json_eql(comment.send(a.to_sym).to_json).at_path("question/comments/0/#{a}") }
        end
      end

      context 'attachments' do
        it { expect(response.body).to have_json_size(1).at_path('question/attachments') }

        %w(id identifier url).each do |a|
          it { expect(response.body).to be_json_eql(attachment.send(a.to_sym).to_json).at_path("question/attachments/0/#{a}") }
        end
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        get api_v1_question_path(id: question), format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        get api_v1_question_path(id: question, access_token: 'invalid_token'), format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    context 'authorized' do
      let(:user) { create :user }
      let(:token) { create(:access_token, resource_owner_id: user.id).token }
      let(:attributes) { attributes_for :question }

      context 'with valid attributes' do
        it 'should save the question to database' do
          expect {
            post api_v1_questions_path(question: attributes, access_token: token), format: :json
          }.to change(user.questions, :count).by(1)
        end

        context 'response' do
          before { post api_v1_questions_path(question: attributes, access_token: token), format: :json }

          it { expect(response).to have_http_status(:created) }
          it { attributes.each { |k, v| expect(response.body).to be_json_eql(v.to_json).at_path("question/#{k}") } }
        end
      end

      context 'with invalid attributes' do
        let(:invalid_attributes) { attributes_for :invalid_question }

        it 'should does not save the invalid question' do
          expect {
            post api_v1_questions_path(question: invalid_attributes, access_token: token), format: :json
          }.to_not change(Question, :count)
        end

        context 'response' do
          before { post api_v1_questions_path(question: invalid_attributes, access_token: token), format: :json }

          it { expect(response).to have_http_status(:unprocessable_entity) }
          it { expect(response.body).to have_json_path('errors') }
        end
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        post api_v1_questions_path, format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        post api_v1_questions_path(access_token: 'invalid_token'), format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
