require 'faraday'

module Fyber

  module Response

    class ProcessError < Faraday::Response::Middleware

      private
      def on_complete(response)
        if error = Fyber::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
