require 'sinatra'
require_relative 'fyber/client'
require_relative 'fyber/errors'

get '/' do
  erb :offers_form
end

get '/offers' do
  client = Fyber::Client.new
  begin
    @offers = client.offers(params["uid"], params["pub0"], params["page"])
    erb :offers
  rescue Fyber::BadRequest, Fyber::Forbidden, Fyber::Unauthorized => exception
    @params = params
    @error = "Error: #{exception.message}"
    erb :offers_form
  rescue Exception => exception
    @error = "Unexpected error has happen, try again"
    erb :offers_form
  end
end
