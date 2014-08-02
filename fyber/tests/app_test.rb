ENV['RACK_ENV'] = 'test'

require_relative '../app'
require 'rspec'
require 'rack/test'

describe 'Fyber Challenge app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

    before(:each) do
      ENV['FYBER_API_KEY'] = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1f'
      ENV['FYBER_LOCALE'] = 'de'
      ENV['FYBER_DEVICE_ID']= '2b6f0cc904d137be2e1730235f5664094b831186'
      ENV['FYBER_OFFER_TYPES'] = '112'
      ENV['FYBER_APPID'] = '157'
    end


  it "Renders main page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include "Fyber Challenge"
    expect(last_response.body).to include "uid"
    expect(last_response.body).to include "pub0"
    expect(last_response.body).to include "page"
  end

  it "Get no results from a query" do
    params = {}
    params[:uid] = "player2"
    params[:pub0] = "campaign"
    params[:page] = 1
    post "/offers", params
    expect(last_response).to be_ok
    expect(last_response.body).to include "No offers"
    expect(last_response.body).to include "New search"
  end

  it "Get error msg when api key is bad configured" do
    ENV['FYBER_API_KEY'] = 'b07a12df7d52e6c118e5d47d3f9e60135b109a1'

    params = {}
    params[:uid] = "player2"
    params[:pub0] = "campaign"
    params[:page] = 1
    post "/offers", params
    expect(last_response).to be_ok
    expect(last_response.body).to include "Error: An invalid hashkey for this appid was given as a parameter in the request."
  end

  it "Get error msg when parameters are wrong" do
    params = {}
    params[:uid] = "player2"
    params[:pub0] = "campaign"
    params[:page] = 0
    post "/offers", params
    expect(last_response).to be_ok
    expect(last_response.body).to include "Error: A non-existing page was requested with the parameter page."
  end

end
