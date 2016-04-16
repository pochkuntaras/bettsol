# == Schema Information
#
# Table name: voices
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  votable_id   :integer
#  votable_type :string
#  solution     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Voice, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :solution }
  it { should validate_numericality_of(:solution).only_integer }
  it { should validate_inclusion_of(:solution).in_array([-1, 1]) }
end
