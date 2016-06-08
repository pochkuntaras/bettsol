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

class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true, touch: true

  mount_uploader :file, AttachmentUploader

  validates :file, presence: true

  def identifier
    file.identifier
  end

  def url
    file.url
  end
end
