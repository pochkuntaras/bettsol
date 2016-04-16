module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_and_authorize_votable, only: [:like, :dislike, :indifferent]
    before_action :check_voice, only: [:like, :dislike]
  end

  def like
    @votable.like(current_user)
    render json: { rating: @votable.rating }
  end

  def dislike
    @votable.dislike(current_user)
    render json: { rating: @votable.rating }
  end

  def indifferent
    @votable.indifferent(current_user)
    render json: { rating: @votable.rating }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_and_authorize_votable
    @votable = model_klass.find(params[:id])

    if current_user.is_author?(@votable)
      render json: { error: 'Access forbidden.' }, status: :forbidden
    end
  end

  def check_voice
    if current_user.voted_for?(@votable)
      render json: { error: 'You voted already!' } , status: :forbidden
    end
  end
end
