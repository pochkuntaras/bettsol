require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create :access_token }
  let(:question) { create :question }
  let!(:answer) { create :answer, question: question }

  describe 'GET #index' do
    context 'authorized' do
      before { get api_v1_question_answers_path(question_id: question, access_token: access_token.token), format: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to have_json_size(1).at_path('answers') }

      %w(id question_id content created_at updated_at best).each do |a|
        it { expect(response.body).to be_json_eql(answer.send(a.to_sym).to_json).at_path("answers/0/#{a}") }
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        get api_v1_question_answers_path(question_id: question), format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        get api_v1_question_answers_path(question_id: question, access_token: 'invalid_token'), format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    let(:comments) { create_list :comment, 2, commentable: answer }
    let!(:comment) { comments.first }
    let!(:attachment) { create :attachment, attachable: answer }

    context 'authorized' do
      before { get api_v1_question_answer_path(question_id: question, id: answer, access_token: access_token.token), format: :json }

      it { expect(response).to have_http_status(:ok) }

      %w(id question_id content created_at updated_at best).each do |a|
        it { expect(response.body).to be_json_eql(answer.send(a.to_sym).to_json).at_path("answer/#{a}") }
      end

      context 'comments' do
        it { expect(response.body).to have_json_size(2).at_path('answer/comments') }

        %w(id content created_at updated_at).each do |a|
          it { expect(response.body).to be_json_eql(comment.send(a.to_sym).to_json).at_path("answer/comments/0/#{a}") }
        end
      end

      context 'attachments' do
        it { expect(response.body).to have_json_size(1).at_path('answer/attachments') }

        %w(id identifier url).each do |a|
          it { expect(response.body).to be_json_eql(attachment.send(a.to_sym).to_json).at_path("answer/attachments/0/#{a}") }
        end
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        get api_v1_question_answer_path(question_id: question, id: answer), format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        get api_v1_question_answer_path(question_id: question, id: answer, access_token: 'invalid_token'), format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    context 'authorized' do
      let(:user) { create :user }
      let(:token) { create(:access_token, resource_owner_id: user.id).token }
      let(:attributes) { attributes_for :answer }

      context 'with valid attributes' do
        it 'should save the answer with user to database' do
          expect {
            post api_v1_question_answers_path(question_id: question, answer: attributes, access_token: token), format: :json
          }.to change(user.answers, :count).by(1)
        end

        it 'should save the answer to question to database' do
          expect {
            post api_v1_question_answers_path(question_id: question, answer: attributes, access_token: token), format: :json
          }.to change(question.answers, :count).by(1)
        end

        context 'response' do
          before { post api_v1_question_answers_path(question_id: question, answer: attributes, access_token: token), format: :json }

          it { expect(response).to have_http_status(:created) }
          it { expect(response.body).to be_json_eql(question.id).at_path('answer/question_id') }
          it { attributes.each { |k, v| expect(response.body).to be_json_eql(v.to_json).at_path("answer/#{k}") } }
        end
      end

      context 'with invalid attributes' do
        let(:invalid_attributes) { attributes_for :invalid_answer }

        it 'should does not save the invalid answer' do
          expect {
            post api_v1_question_answers_path(question_id: question, answer: invalid_attributes, access_token: token), format: :json
          }.to_not change(Answer, :count)
        end

        context 'response' do
          before { post api_v1_question_answers_path(question_id: question, answer: invalid_attributes, access_token: token), format: :json }

          it { expect(response).to have_http_status(:unprocessable_entity) }
          it { expect(response.body).to have_json_path('errors') }
        end
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        post api_v1_question_answers_path(question_id: question), format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        post api_v1_question_answers_path(question_id: question, access_token: 'invalid_token'), format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
