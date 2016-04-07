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

FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/smile.txt") }
  end
end
