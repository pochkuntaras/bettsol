# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  commentable_id   :integer          not null
#  commentable_type :string           not null
#  content          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  log_in_user

  let(:question) { create :question }
  let(:attributes_comment) { attributes_for :comment }
  let(:attributes_invalid_comment) { attributes_for :invalid_comment }

  describe 'POST #create' do
    it 'should save the comment to the question' do
      expect {
        post :create, question_id: question, comment: attributes_comment, format: :json
      }.to change(question.comments, :count).by(1)
    end

    it 'should does not save the invalid comment' do
      expect {
        post :create, question_id: question, comment: attributes_invalid_comment, format: :json
      }.to_not change(Comment, :count)
    end

    context 'with valid attributes' do
      before { post :create, question_id: question, comment: attributes_comment, format: :json }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:comment).user).to eq @user }
      it { expect(response_json['notice']).to be_present }
    end

    context 'with invalid attributes' do
      before { post :create, question_id: question, comment: attributes_invalid_comment, format: :json }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response_json['errors']).to be_present }
    end
  end
end
