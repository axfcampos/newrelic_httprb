DependencyDetection.defer do
  named :http_rb

  depends_on do
    defined?(HTTP) && defined?(HTTP::Client)
  end

  executes do
    ::NewRelic::Agent.logger.info 'Installing http.rb instrumentation'
    require 'new_relic/agent/cross_app_tracing'
    require 'newrelic_httprb/wrappers'
  end

  executes do
    class HTTP::Client
      def perform_with_newrelic_trace(request, options)
        wrapped_request = ::NewRelicHTTP::HTTPRequest.new(request)

        ::NewRelic::Agent::CrossAppTracing.tl_trace_http_request(wrapped_request) do
          # RUBY-1244 Disable further tracing in request to avoid double
          # counting if connection wasn't started (which calls request again).
          response = perform_without_newrelic_trace(request, options)
          ::NewRelicHTTP::HTTPResponse.new(response)
        end

        response
      end

      alias perform_without_newrelic_trace perform
      alias perform perform_with_newrelic_trace
    end
  end
end
