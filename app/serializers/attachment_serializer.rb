# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string           not null
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :url
end
