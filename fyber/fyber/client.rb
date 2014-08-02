require_relative 'default'
require_relative 'errors'
require 'faraday'
require 'addressable/uri'
require 'digest/sha1'



module Fyber

  class Client

    def initialize(options = {})

      Fyber::Default.options.each do |key, value|
        instance_variable_set(:"@#{key}", options[key] || value)
      end

      @conn = Faraday.new(url: Fyber::Default.api_endpoint)

    end

    def calculate_hash(options)
      uri = Addressable::URI.new
      uri.query_values = options
      query = uri.query
      query = "#{query}&#{@api_key}"
      Digest::SHA1.hexdigest query
    end

    def timestamp
      Time.now.to_i
    end

    # It should calculate device ip instead of a hardcoded one.
    def ip
      '109.235.143.113'
    end

    def format
      'json'
    end

    def options(uid, pub0, page)
      options = {}

      Fyber::Default.api_call_params.each do |key|
        options[key] = instance_variable_get(:"@#{key}") || send(key)
      end

      options[:uid] = uid
      options[:pub0] = pub0
      options[:page] = page

      options[:hashkey] = calculate_hash(options)
      options
    end

    def check_response(response)
      signature = response.headers['x-sponsorpay-response-signature']
      body_with_api_key = "#{response.body}#{@api_key}"
      response_hash = Digest::SHA1.hexdigest body_with_api_key
      if response_hash != signature
        raise Fyber::InvalidTokenResponse
      end
    end

    def offers(uid, pub0, page)
      options = options(uid, pub0, page)
      response = @conn.get offers_path, options
      check_response(response)
      response
    end

    def offers_path
      "feed/v1/offers.json"
    end

  end

end
