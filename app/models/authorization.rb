# == Schema Information
#
# Table name: authorizations
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  provider           :string           not null
#  uid                :string           not null
#  confirmation_token :string           not null
#  confirmed_at       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Authorization < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  before_save :set_confirmation_token

  after_save :deliver_confirmation

  private

  def set_confirmation_token
    self.confirmation_token = Devise.friendly_token
  end

  def deliver_confirmation
    AuthorizationMailer.confirm(self).deliver_now unless confirmed_at
  end
end
