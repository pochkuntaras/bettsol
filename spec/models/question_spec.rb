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

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'attachable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
end
