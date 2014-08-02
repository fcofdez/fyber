require_relative 'fyber/client'
a = Fyber::Client.new
res = a.offers("player1", "campaign1", 1)
puts res.headers
puts res.body
