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

  validates :user_id, :title, :content, presence: true
end
