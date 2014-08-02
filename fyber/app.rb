require 'sinatra'
require_relative 'fyber/client'

get '/' do
  erb :offers_form
end

post '/offers' do
  client = Fyber::Client.new
  @offers = client.offers(params["uid"], params["pub0"], params["page"])
  erb :offers
end
