require 'rails_helper'

shared_examples 'API Authorizable' do
  context 'authorized' do
    before { do_request access_token: token }

    it { expect(response).to have_http_status(:success) }
  end

  context 'unauthorized' do
    it 'returns unauthorized status if there is no access token' do
      do_request
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized status if access token is invalid' do
      do_request access_token: :invalid_token
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
