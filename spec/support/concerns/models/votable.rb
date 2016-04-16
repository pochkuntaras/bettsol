require 'rails_helper'

shared_examples 'votable' do
  let (:model) { create described_class.to_s.underscore.to_sym }
  let (:user) { create :user }

  it { should have_many(:voices).dependent(:destroy) }

  describe 'like' do
    before { model.like(user) }

    it { expect(model.voices.count).to eq(1) }
    it { expect(model.voices.find_by(user: user).solution).to eq(1) }
  end

  describe 'dislike' do
    before { model.dislike(user) }

    it { expect(model.voices.count).to eq(1) }
    it { expect(model.voices.find_by(user: user).solution).to eq(-1) }
  end

  describe 'indifferent' do
    before do
      model.like(user)
      model.indifferent(user)
    end

    it { expect(model.voices.count).to eq(0) }
  end

  describe 'rating' do
    before { model.like(user) }

    it { expect(model.rating).to eq(1) }
  end
end
