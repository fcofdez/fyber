require 'faraday'
require 'json'

module Fyber
  module Response

    class JsonParser < Faraday::Response::Middleware

      private

      def on_complete(env)
        if env[:response_headers]['content-type'] =~ /json/
          env[:body] = JSON.parse env[:body]
        end
      end
    end
  end
end
