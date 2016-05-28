require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    %w(question answer comment user).each do |scope|
      it "should search in scope question #{scope}" do
        expect(scope.classify.constantize).to receive(:search).with('Some text', page: nil)
        get :index, query: 'Some text', scope: scope
      end
    end

    context 'responce' do
      before { get :index }

      it { expect(response).to have_http_status :success }
      it { expect(response).to render_template :index }
    end
  end
end
