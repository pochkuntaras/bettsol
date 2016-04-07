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

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachable }
  it { should validate_presence_of :file }
end
