VkontakteApi.configure do |config|
  # Authorization parameters (not needed when using an external authorization):
  config.app_id       = '3472115'
  config.app_secret   = '2p6u2LIKlhC7CxecCIIT'
  config.redirect_uri = '78.137.5.149:3000/user_profile/callback'
  
  # Faraday adapter to make requests with:
  # config.adapter = :net_http
  
  # HTTP verb for API methods (:get or :post)
  # config.http_verb = :get
  
  # Logging parameters:
  # log everything through the rails logger
  config.logger = Rails.logger
  
  # log requests' URLs
  # config.log_requests = true
  
  # log response JSON after errors
  # config.log_errors = true
  
  # log response JSON after successful responses
  # config.log_responses = false
end

# create a short alias VK for VkontakteApi module
# VkontakteApi.register_alias
