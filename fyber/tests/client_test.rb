require 'faraday'
require_relative '../fyber/client'
require_relative '../fyber/errors'
require_relative '../fyber/default'


describe Fyber::Client do

  describe "client configuration" do
    before do
      ENV['FYBER_API_KEY'] = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
      ENV['FYBER_LOCALE'] = 'de'
      ENV['FYBER_DEVICE_ID']= '2b6f0cc904d137be2e1730235f5664094b831186'
      ENV['FYBER_OFFER_TYPES'] = '112'
      ENV['FYBER_APPID'] = '157'
    end

    it "get default configuration from env vars" do
      client = Fyber::Client.new
      expect(client.instance_variable_get(:"@api_key")).to eq('b07a12df7d52e6c118e5d47d3f9e60135b109a1f')
      expect(client.instance_variable_get(:"@locale")).to eq('de')
      expect(client.instance_variable_get(:"@offer_types")).to eq('112')
      expect(client.instance_variable_get(:"@device_id")).to eq('2b6f0cc904d137be2e1730235f5664094b831186')
      expect(client.instance_variable_get(:"@appid")).to eq('157')
    end

    it "could be configured via hash" do
      options = {}

      Fyber::Default.keys.each do |key|
        options[key] = "#{key}"
      end

      options[:connection_options] = {}

      client = Fyber::Client.new(options)

      Fyber::Default.keys.each do |key|
        if key == :connection_options
          expect(client.instance_variable_get(:"@#{key}")).to eq({:builder=>"middleware", :url=>"http://api.sponsorpay.com"})
        else
          expect(client.instance_variable_get(:"@#{key}")).to eq("#{key}")
        end
      end
    end
  end

  describe "Security checks" do
    before do
      @stubs = Faraday::Adapter::Test::Stubs.new

      middleware = Fyber::Default.middleware
      middleware.adapter :test, @stubs

      @options = {}
      @options[:builder] = middleware
    end

    it "Raises an exception if header hash is incorrect" do
      json_response = File.read("tests/fixtures/jsonresponse")
      response_headers = { 'content-type' => 'application/json',
                           'x-sponsorpay-response-signature' => 'wrong'}
      @stubs.get('feed/v1/offers.json') { |env| [200, response_headers, json_response] }
      client = Fyber::Client.new(@options)
      expect{client.offers("player2", "campaign", 1)}.to raise_error Fyber::InvalidTokenResponse
    end

  end

  describe "api calls" do

    before do
      @stubs = Faraday::Adapter::Test::Stubs.new

      middleware = Faraday::RackBuilder.new do |builder|
        builder.use Fyber::Response::ProcessError
        builder.use Fyber::Response::JsonParser
        builder.adapter :test, @stubs
      end

      @options = {}
      @options[:builder] = middleware

    end

    it "Generate OfferList object" do
      json_response = File.read("tests/fixtures/jsonresponse")
      @stubs.get('feed/v1/offers.json') { |env| [200, {'content-type' => 'application/json'}, json_response] }

      client = Fyber::Client.new(@options)
      offers = client.offers("player2", "campaign", 1)
      expect(offers.first).not_to be_nil
      expect(offers.first.title).to eq(" Tap  Fish")
      expect(offers.first.payout).to eq("90")
      expect(offers.first.thumbnail_url).to eq("http://cdn.sponsorpay.com/assets/1808/icon175x175- 2_square_60.png")
    end

    it "Process empty response" do
      json_response = File.read("tests/fixtures/emptyresponse")
      @stubs.get('feed/v1/offers.json') { |env| [200, {'content-type' => 'application/json'}, json_response] }

      client = Fyber::Client.new(@options)
      offers = client.offers("player2", "campaign", 1)
      expect(offers).to be_empty
    end

    it "On 404 raises NotFound Exception" do
      @stubs.get('feed/v1/offers.json') { |env| [404, {}, ''] }

      client = Fyber::Client.new(@options)
      expect{client.offers("player2", "campaign", 1)}.to raise_error Fyber::NotFound
    end

    it "On 500 raises InternalServerError Exception" do

      @stubs.get('feed/v1/offers.json') { |env| [500, {}, ''] }

      client = Fyber::Client.new(@options)

      expect{client.offers("player2", "campaign", 1)}.to raise_error Fyber::InternalServerError
    end

    it "On 403 raises Forbidden Exception" do
      @stubs.get('feed/v1/offers.json') { |env| [403, {}, ''] }

      client = Fyber::Client.new(@options)

      expect{client.offers("player2", "campaign", 1)}.to raise_error Fyber::Forbidden
    end

    it "On 401 raises Unauthorized Exception" do
      @stubs.get('feed/v1/offers.json') { |env| [401, {}, ''] }

      client = Fyber::Client.new(@options)

      expect{client.offers("player2", "campaign", 1)}.to raise_error Fyber::Unauthorized
    end


    it "On 400 raises BadRequest Exception" do
      @stubs.get('feed/v1/offers.json') { |env| [400, {}, ''] }

      client = Fyber::Client.new(@options)

      expect{client.offers("player2", "campaign", 1)}.to raise_error Fyber::BadRequest
    end


  end
end
