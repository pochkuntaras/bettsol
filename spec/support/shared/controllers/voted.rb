require 'rails_helper'

shared_examples 'voted' do
  describe 'PATCH #like' do
    it { expect { patch :like, id: votable, format: :json }.to change(votable.voices, :count).by(1) }
    it { expect { patch :like, id: user_votable, format: :json }.to_not change(Voice, :count) }

    context 'current user is author votable' do
      before { patch :like, id: user_votable, format: :json }

      it { expect(assigns(:votable)).to eq user_votable }
      it { expect(response).to have_http_status(:forbidden) }
      it { expect(response_json['error']).to eq 'Access forbidden.' }
    end

    context 'current user is not author votable' do
      before { patch :like, id: votable, format: :json }

      it { expect(assigns(:votable)).to eq votable }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response_json['rating']).to eq votable.rating }
      it { expect { patch :like, id: votable, format: :json }.to_not change(votable.voices, :count) }

      it 'should response json with error if user trying vote again' do
        patch :like, id: votable, format: :json
        expect(response_json['error']).to eq 'You voted already!'
      end
    end
  end

  describe 'PATCH #dislike' do
    it { expect { patch :dislike, id: votable, format: :json }.to change(votable.voices, :count).by(1) }
    it { expect { patch :dislike, id: user_votable, format: :json }.to_not change(Voice, :count) }

    context 'current user is author votable' do
      before { patch :dislike, id: user_votable, format: :json }

      it { expect(assigns(:votable)).to eq user_votable }
      it { expect(response).to have_http_status(:forbidden) }
      it { expect(response_json['error']).to eq 'Access forbidden.' }
    end

    context 'current user is not author votable' do
      before { patch :dislike, id: votable, format: :json }

      it { expect(assigns(:votable)).to eq votable }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response_json['rating']).to eq votable.rating }
      it { expect { patch :like, id: votable, format: :json }.to_not change(votable.voices, :count) }

      it 'should response json with error if user trying vote again' do
        patch :like, id: votable, format: :json
        expect(response_json['error']).to eq 'You voted already!'
      end
    end
  end

  describe 'DELETE #indifferent' do
    before { patch :like, id: votable, format: :json }

    it { expect { delete :indifferent, id: user_votable, format: :json }.to_not change(Voice, :count) }
    it { expect { delete :indifferent, id: votable, format: :json }.to change(votable.voices, :count).by(-1) }

    context 'current user is author votable' do
      before { delete :indifferent, id: user_votable, format: :json }

      it { expect(assigns(:votable)).to eq user_votable }
      it { expect(response).to have_http_status(:forbidden) }
      it { expect(response_json['error']).to eq 'Access forbidden.' }
    end

    context 'current user is not author votable' do
      before { delete :indifferent, id: votable, format: :json }

      it { expect(assigns(:votable)).to eq votable }
      it { expect(response).to have_http_status(:ok) }
      it { expect(response_json['rating']).to eq votable.rating }
    end
  end
end
