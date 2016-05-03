module OmniAuthMacros
  def set_auth(provider, email = nil)
    provider_info = { provider: provider, uid: rand(1000..5000), info: { email: email } }
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(provider_info)
  end
end
