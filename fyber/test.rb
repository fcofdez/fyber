require_relative 'fyber/client'
a = Fyber::Client.new
res = a.offers("player2", "campaign", 1)
puts res.document
