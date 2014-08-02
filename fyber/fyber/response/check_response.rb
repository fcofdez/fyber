require 'faraday'
require 'json'
require_relative '../default'
require_relative '../errors'


module Fyber
  module Response

    class HashChecker < Faraday::Response::Middleware

      private

      def on_complete(env)
        signature = env[:response_headers]['x-sponsorpay-response-signature']
        api_key = Fyber::Default.api_key
        body_with_api_key = "#{env[:body]}#{api_key}"
        response_hash = Digest::SHA1.hexdigest body_with_api_key
        if response_hash != signature
          raise Fyber::InvalidTokenResponse
        end
      end
    end
  end
end
