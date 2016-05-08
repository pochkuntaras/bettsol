require 'rails_helper'

describe 'Profiles API' do
  let(:me) { create :user }
  let(:access_token) { create :access_token, resource_owner_id: me.id }

  describe 'GET #index' do
    context 'authorized' do
      let!(:others) { create_list :user, 2 }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.body).to be_json_eql(others.to_json) }
      it { expect(response.body).to_not include_json(me.to_json) }

      %w(id email created_at updated_at).each do |attr|
        it { expect(response.body).to be_json_eql(others.first.send(attr.to_sym).to_json).at_path("0/#{attr}") }
      end

      %w(password encrypted_password).each do |attr|
        it { expect(response.body).to_not have_json_path("0/#{attr}") }
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        get '/api/v1/profiles', format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        get '/api/v1/profiles', format: :json, access_token: 'invalid_token'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #me' do
    context 'authorized' do
      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it { expect(response).to have_http_status(:ok) }

      %w(id email created_at updated_at).each do |attr|
        it { expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr) }
      end

      %w(password encrypted_password).each do |attr|
        it { expect(response.body).to_not have_json_path(attr) }
      end
    end

    context 'unauthorized' do
      it 'returns unauthorized status if there is no access token' do
        get '/api/v1/profiles/me', format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauthorized status if access token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: 'invalid_token'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
