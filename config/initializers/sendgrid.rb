ActionMailer::Base.smtp_settings = {
  domain: 'bookbybit.app',
  address: "smtp.sendgrid.net",
  port: 587,
  authentication: :plain,
  user_name: 'apikey',
  password: ENV['SNEDGRID_API_KEY'],
}
