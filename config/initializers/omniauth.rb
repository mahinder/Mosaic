OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '163808423764776', 'c05c446dd15f385af57d153db1caf7d1'
end