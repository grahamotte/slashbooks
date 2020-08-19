Rails.application.configure do
  config.action_controller.perform_caching = true
  config.action_mailer.default_url_options = { host: 'slashbooks.app', protocol: 'https'}
  config.action_mailer.perform_caching = false
  config.active_record.dump_schema_after_migration = false
  config.active_storage.service = :bb
  config.active_support.deprecation = :notify
  config.assets.compile = false
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.eager_load = true
  config.i18n.fallbacks = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
end
