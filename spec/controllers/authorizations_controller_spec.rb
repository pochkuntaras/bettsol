# == Schema Information
#
# Table name: authorizations
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider           :string           not null
#  uid                :string           not null
#  confirmation_token :string           not null
#  confirmed_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  let(:email) { 'user@example.com' }
  let(:invalid_email) { 'invalid_email' }

  describe 'GET #new' do
    before { get :new }

    it { expect(assigns(:email)).to eq nil }
    it { expect(response).to render_template :new }
  end

  describe 'POST #create' do
    context 'with valid provider data' do
      let!(:user) { create :user }

      before { session['devise.provider_data'] = { provider: 'provider', uid: rand(1000..5000) } }

      it { expect { post :create, email: email }.to change(User, :count).by(1) }
      it { expect { post :create, email: email }.to change{ActionMailer::Base.deliveries.count}.by(1) }
      it { expect { post :create, email: user.email }.to change{ActionMailer::Base.deliveries.count}.by(1) }
      it { expect { post :create, email: user.email }.not_to change(User, :count)}
      it { expect { post :create, email: user.email }.to change(user.authorizations, :count).by(1)}
      it { expect { post :create, email: invalid_email }.not_to change(User, :count)}
      it { expect { post :create, email: invalid_email }.not_to change{ActionMailer::Base.deliveries.count} }

      it 'should redirect to user registration page' do
        post :create, email: invalid_email
        expect(response).to redirect_to new_user_registration_path
      end

      context 'with valid email' do
        before { post :create, email: email }

        it { expect(response).to redirect_to root_path }
        it { change{User.find_by_email(email).authorizations.count}.by(1) }
      end
    end

    context 'with invalid provider data' do
      before { session['devise.provider_data'] = { provider: nil, uid: nil } }

      it { expect { post :create, email: email }.not_to change(User, :count)}
      it { expect { post :create, email: email }.not_to change(Authorization, :count)}
      it { expect { post :create, email: email }.not_to change{ActionMailer::Base.deliveries.count} }

      it 'should redirect to user registration page' do
        post :create, email: email
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end

  describe 'GET #confirm' do
    let!(:authorization) { create :authorization }

    context 'with valid confirmation token' do
      before { get :confirm, id: authorization, token: authorization.confirmation_token }

      it { expect(controller.current_user).to eq authorization.user }

      it 'should confirm the authorization' do
        authorization.reload
        expect(authorization.confirmed_at).to be_present
      end
    end

    context 'with invalid confirmation token' do
      before { get :confirm, id: authorization, token: Devise.friendly_token }

      it { expect(response).to redirect_to root_path }

      it 'should does not confirm the authorization' do
        authorization.reload
        expect(authorization.confirmed_at).to be_nil
      end
    end
  end
end
