ActionMailer::Base.smtp_settings = {
  domain: 'slashbooks.app',
  address: "smtp.sendgrid.net",
  port: 587,
  authentication: :plain,
  user_name: 'apikey',
  password: ENV['SNEDGRID_API_KEY'],
}
