module Fyber

    module Default

        API_ENDPOINT = "http://api.sponsorpay.com".freeze

        MEDIA_TYPE   = "application/json"

        USER_AGENT   = "Fyber Ruby Client".freeze

        # # Default Faraday middleware stack
        # MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
        #     builder.use Octokit::Response::RaiseError
        #     builder.use Octokit::Response::FeedParser
        #     builder.adapter Faraday.default_adapter
        # end

        class << self

            def keys
                @keys ||= [
                    :api_key,
                    :api_endpoint,
                    :device_id,
                    :appid,
                    :offer_types,
                    :locale,
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

            def api_endpoint
                ENV['FYBER_API_ENDPOINT'] || API_ENDPOINT
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
