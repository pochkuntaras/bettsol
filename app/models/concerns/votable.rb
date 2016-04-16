module Votable
  extend ActiveSupport::Concern

  included do
    has_many :voices, as: :votable, dependent: :destroy
  end

  def like(user)
    user_voice(user).update(solution: 1)
  end

  def dislike(user)
    user_voice(user).update(solution: -1)
  end

  def indifferent(user)
    user_voice(user).destroy
  end

  def rating
    voices.sum(:solution)
  end

  private

  def user_voice(user)
    voices.find_or_initialize_by(user: user)
  end
end
