# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:voices).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '534038') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '534038')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'provider has not provided email address' do
      it { expect(User.find_for_oauth(auth)).to be_nil }
    end

    context 'user has not authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '534038', info: { email: user.email }) }

      context 'user already exists' do
        it { expect { User.find_for_oauth(auth) }.to_not change(User, :count) }
        it { expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1) }
        it { expect(User.find_for_oauth(auth)).to eq user }

        it 'should create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '534038', info: { email: 'user@example.com' }) }

        it { expect { User.find_for_oauth(auth) }.to change(User, :count).by(1) }

        context 'created authorization' do
          let(:user) { User.find_for_oauth(auth) }

          it { expect(user).to be_a(User) }
          it { expect(user.email).to eq auth.info.email }
          it { expect(user.authorizations).to_not be_empty }

          it 'should create authorization with provider and uid' do
            authorization = user.authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end
  end
end
