#require 'helper'
require_relative '../fyber/client'
require_relative '../fyber/default'


describe Fyber::Client do

  describe "client configuration" do
    before do
      env['FYBER_API_KEY'] = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
      env['FYBER_LOCALE'] = 'de'
      env['FYBER_DEVICE_ID']= '2b6f0cc904d137be2e1730235f5664094b831186'
      env['FYBER_OFFER_TYPES'] = '112'
      env['FYBER_APPID'] = '157'
    end

    it "get default configuration from env vars" do
      client = Fyber::Client.new
      Fyber::Default.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end
  end

end
