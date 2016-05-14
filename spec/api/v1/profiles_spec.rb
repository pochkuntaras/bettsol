require 'rails_helper'

describe 'Profiles API' do
  let(:me) { create :user }
  let(:token) { create(:access_token, resource_owner_id: me.id).token }

  describe 'GET #index' do
    let(:users) { create_list :user, 2 }
    let!(:user) { users.first }

    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Attributable', 'user', %w(id email created_at updated_at), %w(password encrypted_password), 'profiles/0/'

    def do_request(params = {})
      get api_v1_profiles_path(params), format: :json
    end

    context 'response' do
      before { do_request access_token: token }

      it { expect(response.body).to be_json_eql(users.to_json).at_path('profiles') }
      it { expect(response.body).to_not include_json(me.to_json) }
    end
  end

  describe 'GET #me' do
    it_behaves_like 'API Authorizable'
    it_behaves_like 'API Attributable', 'me', %w(id email created_at updated_at), %w(password encrypted_password)

    def do_request(params = {})
      get me_api_v1_profiles_path(params), format: :json
    end
  end
end
