ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_url_options[:host] = "localhost:3000"
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :authentication       => "plain",
  :enable_starttls_auto => true,
  :user_name            => "MeterSoft.net@gmail.com",
  :password             => "meter3131A"
}