BusinessAnalytics.configure do |config|
  config.logger LogStashLogger.new(port: 5228)
  config.analytic_routes YAML.load_file("#{Rails.root}/config/analytic_routes.yml")
end
