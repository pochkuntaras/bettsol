require 'rails_helper'

shared_examples 'API Attributable' do |object, present_attributes, not_present_attributes = [], path = ''|
  before { do_request access_token: token }

  present_attributes.each do |a|
    it { expect(response.body).to be_json_eql(send(object).send(a.to_sym).to_json).at_path(path + a) }
  end

  not_present_attributes.each do |a|
    it { expect(response.body).to_not have_json_path(path + a) }
  end
end
