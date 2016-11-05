class BusinessAnalytics
  DEFAULT_EVENT_NAME = 'page_visit'
  VERSION_ID = 1

  def initialize(app)
    @app = app
  end

  # @note Push events to Logstash
  def call(env)
    begin
      @url = Rails.application.routes.recognize_path(
        env['PATH_INFO'], method: env['REQUEST_METHOD']
      )

      req = ActionDispatch::Request.new(env)

      if permitted? || req.get?
        create_event!('info', event_name, env['QUERY_STRING'])
      end
    rescue => e
      puts e
    end

    @app.call(env)
  end

  # @note Writes event to Logstash
  # @param event_type [String] can be: (info, error, debug, warn)
  # @param event_name [String] event name message
  # @param query_string [String] request query string
  def create_event!(event_type, event_name, query_string)
    logger.send(event_type, LogStash::Event.new(message: event_name, locale: @url[:locale], query_string: query_string))
  end

  # @return [Boolean] if current action is permitted
  def permitted?
    current_selected_action.any?
  end

  # @return [Array] current selected action
  def current_selected_action
    permitted_actions.select { |h| h['action'] == @url[:action] }
  end

  # @return [Array] list of permitted actions
  def permitted_actions
    split_array = @url[:controller].split('/')

    # permitted routes from analytics_routes.yml
    analytic_routes.dig("version-#{VERSION_ID}", *split_array) || []
  end

  # @return [String] event name
  def event_name
    if action = current_selected_action.first
      action['event']
    else
      DEFAULT_EVENT_NAME
    end
  end

  class << self
    def configure(&block)
      instance_eval(&block)
    end

    def logger(logstash_instance)
      class_eval do
        define_method :logger do
          logstash_instance
        end
      end
    end

    def analytic_routes(routes_hash)
      class_eval do
        define_method :analytic_routes do
          routes_hash
        end
      end
    end
  end
end
