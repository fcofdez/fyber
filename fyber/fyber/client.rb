require_relative 'default'
require 'faraday'
require "addressable/uri"
require 'digest/sha1'


module Fyber

  class Client

    def initialize(options={})

      Fyber::Default.options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
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
      puts options
      options
    end

    def offers(uid, pub0, page)
      options = options(uid, pub0, page)
      @conn.get offers_path, options
    end

    def offers_path
      "feed/v1/offers.json"
    end

  end

end
