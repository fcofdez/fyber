require_relative 'fyber/client'
a = Fyber::Client.new
puts a.offers("player1", "campaign1", 1).body
