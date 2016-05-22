# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create :question }

  describe 'POST #create' do
    context 'authenticated user' do
      log_in_user

      it { expect { post :create, question_id: question, format: :js }.to change(Subscription, :count).by(1) }

      context 'references' do
        before { post :create, question_id: question, format: :js }

        it { expect(assigns(:subscription).user).to eq @user }
        it { expect(assigns(:subscription).question).to eq question }
      end
    end

    context 'not authenticated user' do
      it { expect { post :create, question_id: question, format: :js }.to_not change(Subscription, :count) }
    end
  end

  describe 'DELETE #destroy' do
    log_in_user

    context 'current user is subscriber' do
      let!(:user_subscription) { create :subscription, user: @user, question: question }

      it 'should contain user subscription' do
        delete :destroy, id: user_subscription, format: :js
        expect(assigns(:subscription)).to eq user_subscription
      end

      it { expect { delete :destroy, id: user_subscription, format: :js }.to change(Subscription, :count).by(-1) }
    end

    context 'current user is not subscriber' do
      let!(:subscription) { create :subscription }

      it { expect { delete :destroy, id: subscription, format: :js }.to_not change(Subscription, :count) }
    end
  end
end
