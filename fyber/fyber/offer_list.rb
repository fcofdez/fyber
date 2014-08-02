module Fyber

  class Offer

    attr_accessor :title, :payout, :thumbnail_url

    def initialize(offer_json)
      @title = offer_json["title"]
      @payout = offer_json["payout"]
      @thumbnail_url = offer_json["thumbnail"]["lowres"]
    end

  end

  class Offers < Array

    def initialize(response)
      response["offers"].each do |offer|
        self.push(Offer.new(offer))
      end
    end

  end

end
