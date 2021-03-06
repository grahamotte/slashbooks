require_relative Rails.root.join('dev_secrets.rb') if File.exists?(Rails.root.join('dev_secrets.rb'))

Rails.application.configure do
  config.action_controller.enable_fragment_cache_logging = true
  config.action_controller.perform_caching = true
  config.action_mailer.default_url_options = { host: 'localhost:3000', protocol: 'http'}
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_storage.service = :bb
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.quiet = true
  config.cache_classes = false
  config.cache_store = :memory_store
  config.consider_all_requests_local = true
  config.eager_load = false
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{2.days.to_i}" }
end
