require 'rails_helper'

shared_examples 'API Collectible' do |object, size, attributes, path = ''|
  before { do_request access_token: token }

  let(:collection) { send object }
  let(:collection_path) { path + object.pluralize }

  it { expect(response.body).to have_json_size(size).at_path(collection_path) }

  attributes.each do |a|
    it { expect(response.body).to be_json_eql(collection.send(a.to_sym).to_json).at_path("#{collection_path}/0/#{a}") }
  end
end
