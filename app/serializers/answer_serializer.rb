# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  content     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  best        :boolean          default(FALSE), not null
#

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :question_id, :content, :created_at, :updated_at, :best

  has_many :comments
  has_many :attachments
end
