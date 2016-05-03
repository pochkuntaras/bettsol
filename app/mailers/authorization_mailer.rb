class AuthorizationMailer < ApplicationMailer
  def confirm(authorization)
    @authorization = authorization
    mail to: authorization.user.email, subject: "Confirm #{authorization.provider} account."
  end
end
