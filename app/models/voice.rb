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

class Voice < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :user_id, :solution, presence: true
  validates :solution, numericality: { only_integer: true }, inclusion: { in: [-1, 1] }
end
