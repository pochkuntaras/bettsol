# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Question < ActiveRecord::Base
  include Attachable, Votable, Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions

  validates :user_id, :title, :content, presence: true

  scope :digest, -> { where created_at: (Time.parse('00:00:00') - 1.day)..(Time.parse('23:59:59') - 1.day) }

  after_commit :subscribe_to_question, on: :create

  private

  def subscribe_to_question
    subscriptions.create(user: user)
  end
end
