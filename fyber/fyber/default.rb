require 'faraday'
require_relative 'response/process_error'
require_relative 'response/parse_json'
require_relative 'response/check_response'


module Fyber

    module Default

        API_ENDPOINT = "http://api.sponsorpay.com".freeze

        MEDIA_TYPE   = "application/json"

        USER_AGENT   = "Fyber Ruby Client".freeze

        MIDDLEWARE = Faraday::RackBuilder.new do |builder|
            builder.use Fyber::Response::ProcessError
            builder.use Fyber::Response::JsonParser
            builder.use Fyber::Response::HashChecker
            builder.adapter Faraday.default_adapter
        end

        class << self

            def keys
                @keys ||= [
                    :api_key,
                    :api_endpoint,
                    :device_id,
                    :appid,
                    :offer_types,
                    :locale,
                    :format,
                    :connection_options,
                    :middleware,
                    :default_media_type,
                    :user_agent
                ]
            end

            def api_call_params
              @api_params ||= [
                :format,
                :appid,
                :locale,
                :device_id,
                :timestamp,
              ]
            end

            def options
                Hash[Fyber::Default.keys.map{|key| [key, send(key)]}]
            end

            def api_key
              ENV['FYBER_API_KEY']
            end

            def appid
              ENV['FYBER_APPID']
            end

            def format
              'json'
            end

            def api_endpoint
                ENV['FYBER_API_ENDPOINT'] || API_ENDPOINT
            end

            def middleware
              MIDDLEWARE
            end

            def device_id
                ENV['FYBER_DEVICE_ID']
            end

            def offer_types
                ENV['FYBER_OFFER_TYPES']
            end

            def locale
                ENV['FYBER_LOCALE']
            end

            def default_media_type
                ENV['FYBER_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
            end

            def user_agent
                ENV['FYBER_USER_AGENT'] || USER_AGENT
            end

            def connection_options
                {
                    :headers => {
                        :accept => default_media_type,
                        :user_agent => user_agent
                    }
                }
            end
        end
    end
end
