# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :voices, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable,
         :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def is_author?(object)
    object.user_id == self.id
  end

  def voted_for?(object)
    voices.exists?(votable: object)
  end

  def self.find_for_oauth(auth, email = nil)
    authorization = Authorization.find_by_provider_and_uid(auth.provider, auth.uid)

    return authorization.user if authorization

    auth_email = auth.info && auth.info.email
    email = email || auth_email

    if email
      user = User.find_by_email(email)

      transaction do
        user = User.create!(email: email, password: Devise.friendly_token, confirmed_at: Time.now) unless user
        user.authorizations.create!(provider: auth.provider, uid: auth.uid, confirmed_at: auth_email ? Time.now : nil)
      end
    end

    user
  end
end
